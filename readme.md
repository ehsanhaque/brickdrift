# Tetris

A web-based Tetris that plays on desktop, phones and tablets. It's a single self-contained `index.html` with no build step and no dependencies.

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

- Guideline-style rules: SRS rotation with wall kicks, 7-bag randomizer, hold, ghost piece, 5-piece preview
- Lock delay with move/rotate resets, DAS/ARR auto-repeat for held keys and buttons
- Scoring for singles through Tetrises, back-to-back Tetris bonus, combos and perfect clears
- Speed increases every 10 lines; best score is saved in the browser
- Responsive layout for portrait phones, landscape phones, tablets and desktops (including notch safe areas)
- Optional sound effects (generated with Web Audio) and vibration feedback on phones
