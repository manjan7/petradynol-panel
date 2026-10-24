# Petradynol Panel – GitHub Actions Keep-Alive

Workflow: `.github/workflows/petradynol-panel.yml`

## Schedule
- Runs every 5 hours at minute 2 (UTC) via cron `2 */5 * * *`.
- Each run is strictly capped at 5 hours (`timeout-minutes: 300`).
- Concurrency group `petradynol-panel` (cancel-in-progress: false) ensures the
  next run waits for the previous one to finish, then sleeps 2 minutes before
  starting the panel again.

## Required secrets / variables
- Secret `RCLONE_CONFIG_B64`: base64-encoded rclone config with a Google Drive
  remote named (by default) `gdrive`.
- Variables (optional, defaults shown):
  - `PANEL_START_CMD` (default `./petradynol-panel`)
  - `PANEL_PORT` (default `3000`)
  - `SERVER_HEALTH_URL` (default `http://localhost:3000/health`)
  - `DRIVE_REMOTE` (default `gdrive:petradynol`)
  - `DB_DIR` (default `./data`)

## Drive as database
- On start: `rclone sync DRIVE_REMOTE/db DB_DIR` (pull live DB).
- Every minute + final: `rclone sync DB_DIR DRIVE_REMOTE/db` (push live files).
- If the runner is killed after the 5-hour cap, the last per-minute sync keeps
  the Drive DB up to date, so the next run resumes from live data and restarts
  the server automatically.
