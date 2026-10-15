-- Brickdrift leaderboard: run this once in your Supabase project's SQL Editor.
--
-- Players are anonymous. The game creates a random id on each device and the server
-- gives that id a random name like "Coral Otter 42". Only names and scores are public;
-- the ids are never readable through the API, so nobody can submit scores for someone else.
--
-- Everything happens through two functions:
--   join_game(p_id)             registers the device (or looks it up) and returns its name and rank
--   submit_score(p_id, p_score) records a finished game and returns the updated standing
-- Direct inserts, updates and deletes through the API are not allowed.

create table if not exists public.players (
  id             uuid primary key,
  name           text not null unique,
  best_score     integer not null default 0 check (best_score between 0 and 5000000),
  games          integer not null default 0,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),  -- when best_score was last raised
  last_submit_at timestamptz
);

create index if not exists players_rank_idx on public.players (best_score desc, updated_at asc);

alter table public.players enable row level security;

-- The API roles may read the public columns only, and never write.
revoke all on public.players from anon, authenticated;
grant select (name, best_score, games, updated_at) on public.players to anon, authenticated;

drop policy if exists "leaderboard is public" on public.players;
create policy "leaderboard is public" on public.players
  for select to anon, authenticated using (true);

-- "Coral Otter 418": an adjective, an animal and a number from 10 to p_max.
-- With p_max = 999 that's 20 x 20 x 990 = 396,000 names; join_game raises p_max if those run out.
drop function if exists public.random_player_name();  -- older version without p_max
create or replace function public.random_player_name(p_max bigint)
returns text
language sql
volatile
set search_path = ''
as $$
  select (array['Coral','Amber','Misty','Swift','Quiet','Brave','Lucky','Sunny','Salty','Mossy',
                'Velvet','Cosmic','Gentle','Bold','Rapid','Silver','Golden','Hidden','Jolly','Nimble'])
           [1 + floor(random() * 20)::int]
      || ' ' ||
         (array['Otter','Heron','Narwhal','Puffin','Seal','Kestrel','Marlin','Walrus','Gecko','Lynx',
                'Badger','Falcon','Squid','Turtle','Manta','Orca','Pelican','Stingray','Beaver','Koala'])
           [1 + floor(random() * 20)::int]
      || ' ' || (10 + floor(random() * (p_max - 9))::bigint)::text;
$$;

-- Name, best score and rank for one player. Rank counts only players who have scored.
-- Ties go to whoever reached the score first, matching the leaderboard's order.
create or replace function public.player_standing(p_id uuid)
returns table (name text, best_score integer, rank bigint, total bigint)
language sql
stable
security definer
set search_path = ''
as $$
  select p.name,
         p.best_score,
         case when p.best_score > 0
              then (select count(*) from public.players q
                    where q.best_score > p.best_score
                       or (q.best_score = p.best_score and (q.updated_at, q.id) < (p.updated_at, p.id))) + 1
         end,
         (select count(*) from public.players q where q.best_score > 0)
  from public.players p
  where p.id = p_id;
$$;

create or replace function public.join_game(p_id uuid)
returns table (name text, best_score integer, rank bigint, total bigint)
language plpgsql
security definer
set search_path = ''
as $$
declare
  attempts int := 0;
begin
  if p_id is null then
    raise exception 'player id is required';
  end if;

  -- Try short names first. Every 10 collisions the number gets two more digits
  -- (999, 99999, 9999999, ...), so a free name is always found.
  while not exists (select 1 from public.players p where p.id = p_id) loop
    attempts := attempts + 1;
    if attempts > 50 then
      raise exception 'could not find a free name';
    end if;
    begin
      insert into public.players (id, name)
      values (p_id, public.random_player_name((power(100, (attempts - 1) / 10) * 1000)::bigint - 1));
    exception when unique_violation then
      null;  -- name already taken, or this id was registered concurrently: check and retry
    end;
  end loop;

  return query select * from public.player_standing(p_id);
end;
$$;

create or replace function public.submit_score(p_id uuid, p_score integer)
returns table (name text, best_score integer, rank bigint, total bigint, improved boolean)
language plpgsql
security definer
set search_path = ''
as $$
declare
  prev_best integer;
  last_at   timestamptz;
begin
  if p_score is null or p_score < 0 or p_score > 5000000 then
    raise exception 'score out of range';
  end if;

  select p.best_score, p.last_submit_at into prev_best, last_at
  from public.players p where p.id = p_id
  for update;

  if not found then
    raise exception 'unknown player';
  end if;

  -- A real game takes at least a few seconds; this stops scripted floods.
  if last_at is not null and last_at > now() - interval '3 seconds' then
    raise exception 'too many submissions, try again shortly';
  end if;

  update public.players p
  set games          = p.games + 1,
      last_submit_at = now(),
      best_score     = greatest(p.best_score, p_score),
      updated_at     = case when p_score > p.best_score then now() else p.updated_at end
  where p.id = p_id;

  return query
    select s.name, s.best_score, s.rank, s.total, p_score > prev_best
    from public.player_standing(p_id) s;
end;
$$;

-- Only the two entry points are callable through the API.
revoke execute on function public.random_player_name(bigint)         from public, anon, authenticated;
revoke execute on function public.player_standing(uuid)              from public, anon, authenticated;
revoke execute on function public.join_game(uuid)                    from public;
revoke execute on function public.submit_score(uuid, integer)        from public;
grant  execute on function public.join_game(uuid)                    to anon, authenticated;
grant  execute on function public.submit_score(uuid, integer)        to anon, authenticated;
