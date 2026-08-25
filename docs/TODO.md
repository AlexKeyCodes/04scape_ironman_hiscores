# TODO

The operational task list for this project. **What's next**, not what or why.

## How to use this file

- **Now** — actively in progress. Cap at 1–3 items (WIP limit).
- **Next** — prioritized queue. Top item is what you'd start next session.
- **Someday** — ideas, maybes, low-priority polish. Re-evaluate every few weeks.
- **Done** — recent wins, date-stamped. Trim after ~2 weeks (git log is the record).

Lifecycle: new idea → Next/Someday · start → Now · done → date-stamp into Done ·
blocked → annotate `(blocked: X)` and move back to Next · cancelled → delete it.

One line per task. No nested sub-task forests. Dates on Done items only.
Substantial work gets a branch file at `docs/todo/<branch>.md` that this line links to.

---

## Now

## Next

- [ ] Player model + roster CRUD (admin-only)
- [ ] Admin auth: hand-rolled sessions, single console-created admin
- [ ] HiscoreFetchService: pull player stats from the Lost City API into snapshots
- [ ] Recurring Solid Queue job to refresh all tracked players
- [ ] Ironman leaderboard page (overall + per-skill) from latest snapshots
- [ ] Custom CSS matching the Lost City hiscores look

## Someday

- [ ] XP gains over time (weekly gains leaderboard) from snapshot history
- [ ] Public player detail page with skill table
- [ ] De-ironing detection heuristics from XP patterns
- [ ] Deploy with Kamal to a VPS

## Done

- [x] 2026-08-25 — README written for open source (license still TBD)
- [x] 2026-08-25 — bin/check runs the full CI suite locally; CI switched from Minitest to RSpec
- [x] 2026-08-25 — Added RSpec (replaced Minitest; removed test/, added spec/)
- [x] 2026-08-25 — Researched Lost City hiscores API (official JSON API exists; documented in CLAUDE.md)
- [x] 2026-08-25 — `rails new` (Rails 8.1, SQLite, importmaps, custom CSS; skipped mailer/mailbox/text/storage/jbuilder)
- [x] 2026-08-25 — CLAUDE.md with project overview, API reference, and coding patterns
- [x] 2026-08-25 — TODO system set up (this file + docs/todo/ + CLAUDE.md protocol)
