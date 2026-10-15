# Brickdrift

> **Disclaimer:** Brickdrift is an experimental, non-commercial project built with AI ([Claude Code](https://claude.com/claude-code)). All code and artwork were written from scratch for this project. It is not affiliated with, endorsed by, or sponsored by the owners of any other game, including The Tetris Company or Tetris Holding, LLC. Tetris® is a registered trademark of Tetris Holding, LLC, mentioned here only to make that non-affiliation clear.

A falling-block puzzle game for desktop, phones and tablets. It's a single self-contained `index.html` with no build step and no dependencies (the display font loads from Google Fonts and falls back to a system font offline).

## Run it

Open `index.html` in any modern browser. To host it, serve the folder as static files (for example GitHub Pages, Netlify, or `python3 -m http.server`).

## Leaderboard

Brickdrift has an optional shared leaderboard backed by [Supabase](https://supabase.com) (free tier is plenty). Players stay anonymous: each device gets a random id stored in the browser and a random name like "Coral Otter 42" chosen by the server. Only names and best scores are stored and shown.

To turn it on:

1. Create a free Supabase project.
2. Open **SQL Editor**, paste in [`supabase/leaderboard.sql`](supabase/leaderboard.sql), and click **Run**. It's safe to run again later.
3. Open **Project Settings → API** (or **Connect**) and copy the **Project URL** and the **anon** / **publishable** key.
4. Paste them into `SUPABASE_URL` and `SUPABASE_KEY` near the leaderboard section of `index.html`.

The anon/publishable key is designed to be public. The database rules only let it read names and scores and call two functions: `join_game` (register a device and get its name) and `submit_score` (record a finished game). Player ids can't be read through the API, so nobody can submit scores under someone else's name. Never put the `service_role` / secret key in the game.

Leave both values empty to play without a leaderboard. The trophy button and player name then stay hidden, and the game makes no network requests.

**Cheating:** the game runs in the player's browser, so a determined player could send a fake score. The server rejects scores above 5,000,000 and more than one submission every 3 seconds per player, but it can't verify that a score was earned. That's fine for a casual leaderboard; if it becomes a problem, scores can be removed in Supabase's Table Editor.

## Controls

| Action       | Keyboard              | Touch                            | Gamepad        |
|--------------|-----------------------|----------------------------------|----------------|
| Move         | ← → (or A / D)        | drag left/right, or ◀ ▶ buttons  | D-pad / stick  |
| Soft drop    | ↓ (or S)              | drag down, or ▼ button           | D-pad down     |
| Hard drop    | Space                 | flick down, or ⤓ button          | D-pad up       |
| Rotate right | ↑ / X / W             | tap the board, or ↻ button       | A / Y          |
| Rotate left  | Z / Q / Ctrl          | ↺ button                         | B / X          |
| Hold         | C / Shift             | flick up, or HOLD button         | LB / RB        |
| Pause        | P / Esc               | pause button                     | Start          |
| Leaderboard  | L                     | trophy button                    | Select / Back  |

On-screen buttons appear automatically on touch devices. The game pauses itself when you switch tabs or apps.

## Features

- An 11 × 22 well with rounded tile-style bricks, a dot-grid background and a dashed landing marker
- Wall-kick rotation, a shuffled bag of all seven pieces, hold, and a five-piece queue
- Lock delay with move/rotate resets, and auto-repeat for held keys and buttons
- Scoring for singles through quads, back-to-back quad bonus, combos and perfect clears
- Speed increases every 10 lines; best score is saved in the browser
- Responsive layout for portrait phones, landscape phones, tablets and desktops (including notch safe areas)
- Optional anonymous online leaderboard (see above)
- Optional sound effects (generated with Web Audio) and vibration feedback on phones
