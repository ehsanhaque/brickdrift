# Brickdrift

> **Disclaimer:** Brickdrift is an experimental, non-commercial project built with AI ([Claude Code](https://claude.com/claude-code)). All code and artwork were written from scratch for this project. It is not affiliated with, endorsed by, or sponsored by the owners of any other game, including The Tetris Company or Tetris Holding, LLC. Tetris® is a registered trademark of Tetris Holding, LLC, mentioned here only to make that non-affiliation clear.

A falling-block puzzle game for desktop, phones and tablets. It's a single self-contained `index.html` with no build step and no dependencies (the display font loads from Google Fonts and falls back to a system font offline).

## Run it

Open `index.html` in any modern browser. To host it, serve the folder as static files (for example GitHub Pages, Netlify, or `python3 -m http.server`).

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

On-screen buttons appear automatically on touch devices. The game pauses itself when you switch tabs or apps.

## Features

- An 11 × 22 well with rounded tile-style bricks, a dot-grid background and a dashed landing marker
- Wall-kick rotation, a shuffled bag of all seven pieces, hold, and a five-piece queue
- Lock delay with move/rotate resets, and auto-repeat for held keys and buttons
- Scoring for singles through quads, back-to-back quad bonus, combos and perfect clears
- Speed increases every 10 lines; best score is saved in the browser
- Responsive layout for portrait phones, landscape phones, tablets and desktops (including notch safe areas)
- Optional sound effects (generated with Web Audio) and vibration feedback on phones
