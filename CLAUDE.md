# CLAUDE.md

## Project Overview

Ironscores — community hiscores for ironman players on 04scape (Lost City,
https://2004.lostcity.rs). The server has no official ironman mode, so this
app maintains its own curated roster of ironmen, pulls their stats from the
Lost City hiscores API on a schedule, and computes ironman-only leaderboards.

Core concepts:

- **Roster**: the list of tracked ironmen. Managed by an admin (single admin
  account, created via the Rails console — no signup, no password reset).
- **Snapshots**: periodically fetched stats per player, stored locally.
  Leaderboards are computed from the latest snapshots; keeping history
  enables XP-gains tracking over time.
- **UI**: intended to visually match the Lost City website (old-school
  RuneScape look). Hand-written CSS — no CSS framework.

## Tech Stack

- Rails 8.1, Ruby 3.4 (`.ruby-version`)
- SQLite for the database (also backs Solid Queue / Solid Cache / Solid Cable)
- Import maps + Hotwire (Turbo/Stimulus) — no JS bundler
- Propshaft with plain custom CSS — no Tailwind
- RSpec (rspec-rails) + Capybara for tests
- Solid Queue for background/recurring jobs (hiscores refresh)
- Kamal + Thruster for deployment
- Skipped on purpose: Action Mailer, Action Mailbox, Action Text,
  Active Storage, jbuilder. Do not reintroduce these without asking.

## Commands

- `bin/setup` — install deps, prepare DB
- `bin/dev` — run the dev server
- `bin/check` — run the full CI suite locally (brakeman, bundler-audit,
  importmap audit, rubocop, rspec). Run before pushing.
- `bundle exec rspec` — run tests (`bundle exec rspec spec/models/foo_spec.rb` for one file)
- `bin/rubocop` — lint (rubocop-rails-omakase)
- `bin/brakeman` — security scan

## Lost City Hiscores API

Announcement: https://2004.lostcity.rs/news/199

- `GET https://2004.lostcity.rs/api/hiscores/player/:username`
  → `[{ "type": skill_id, "level": n, "value": xp, "rank": n }, ...]`
- `GET https://2004.lostcity.rs/api/hiscores/category/:type?rank=N`
  → paginated leaderboard rows (21 per page), `[{ "username", "level", "value", "rank" }, ...]`

Skill type IDs: 0 Overall, 1 Attack, 2 Defence, 3 Strength, 4 Hitpoints,
5 Ranged, 6 Prayer, 7 Magic, 8 Cooking, 9 Woodcutting, 10 Fletching,
11 Fishing, 12 Firemaking, 13 Crafting, 14 Smithing, 15 Mining, 16 Herblore,
17 Agility, 18 Thieving, 21 Runecrafting (19–20 intentionally unused).

Critical caveats:

- `value` is **XP × 10** — divide and truncate before display.
- The player endpoint returns **only ranked skills**. Low-level players are
  missing skills (sometimes even Overall). Treat missing skills as unranked
  and compute totals ourselves when needed.
- Upstream hiscores update **on player logout**, not on a timer. Refresh on
  a modest schedule (~30–60 min); never fetch from the API during a web
  request — serve from our own DB only.
- The API is **rate limited** (limits unpublished). Be polite: sequential
  fetches with small delays, no parallel hammering.
- Usernames use underscores for spaces (e.g. `the_inducted`). The player
  endpoint cannot be used to verify an account exists.

## Task management

Work is tracked in two layers: `docs/TODO.md` (high-level index: Now / Next /
Someday / Done) and `docs/todo/<branch>.md` (granular sub-tasks for substantial
work — filename matches the branch, deleted on merge).

When starting substantial work: sync main, cut the branch, copy
`docs/todo/_template.md` to `docs/todo/<branch>.md`, fill in a first-pass
sub-task list, move the TODO.md line into Now. **Then plan with me and confirm
scope before writing feature code.** Trivial single-line fixes skip all of this.

Follow-ups discovered mid-branch: branch-local → the branch file; outlives the
branch → TODO.md's Next or Someday (never the branch file — it dies on merge).

Updating the TODO is part of finishing any task — same as updating tests or
docs. The task isn't done until TODO.md (and the branch file, if any) reflect
reality. Delete the branch file when the branch merges.

## Coding Patterns

- **Every code change is red-green-refactor:** one failing test, minimum code
  to pass, optional refactor.
- **Always prefer simplicity over complexity.** Write the simplest code that
  does the job — reach for a pattern only when the plain version stops being
  clear.
- **Skinny controllers, fat models.** Controllers handle HTTP concerns
  (params, auth, redirects/rendering); domain logic belongs in models.
- **Business logic goes in POROs** — typically service objects in
  `app/services/` (see Service Class Pattern below). Multi-step operations,
  external API calls, and logic that spans models should not live in
  controllers.
- **Use concerns when possible** to share behavior across models or
  controllers. Shared behavior lives in `app/models/concerns/` and
  `app/controllers/concerns/`.
- **Standard CRUD actions only — no custom controller actions.** When an
  endpoint doesn't fit the standard seven REST actions, create a new
  controller named for the operation and use a standard action on it. Example:
  instead of adding a `refresh` action to `PlayersController`, create a
  `PlayerRefreshesController` and use its `create` action.
- **SOLID principles when applicable.** Rarely needed in practice, but
  consider them during planning and review — don't force them into code that's
  already simple.

### Service Class Pattern

Service classes follow this standardized pattern:

- **Naming**: Class name must end with "Service" (e.g., `HiscoreFetchService`)
- **Constructor**: Use `initialize` method to accept required parameters
- **Main Method**: Must be named `call` - this is the primary public interface
- **Return Value**: The `call` method must return an `OpenStruct` with:
  - `success` (Boolean): Indicates whether the operation succeeded
  - `payload` (Any): The result data when successful, or `nil` when failed
  - `message` (String): Error message when `success` is `false`, not needed
    when `success` is `true`
- **Private Methods**: Use as necessary to keep code organized
- **Location**: Place service classes in `app/services/`
