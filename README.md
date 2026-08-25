# Ironscores

Community hiscores for ironman players on [Lost City](https://2004.lostcity.rs)
(2004scape).

Lost City has no official ironman game mode, so ironman rankings don't exist
on the official hiscores. Ironscores maintains a curated roster of
self-declared ironmen, pulls their stats from the
[Lost City hiscores API](https://2004.lostcity.rs/news/199) on a schedule,
and computes ironman-only leaderboards — overall and per skill.

## How it works

- A single admin manages the roster of tracked ironmen (there's no public
  signup — the admin account is created via the Rails console).
- A recurring background job fetches each tracked player's stats from the
  Lost City API and stores them as snapshots.
- Leaderboards are computed from the latest snapshots and served entirely
  from the local database — the app never calls the Lost City API during a
  page view, keeping well within their rate limits.

## Tech stack

Rails 8.1 · Ruby 3.4 · SQLite (database, cache, job queue, and cable via the
Solid gems) · Hotwire with import maps · hand-written CSS · RSpec.

No Node, no Redis, no external services — a checkout and a Ruby install is
everything you need.

## Getting started

```bash
git clone https://github.com/AlexKeyCodes/04scape_ironman_hiscores.git
cd 04scape_ironman_hiscores
bin/setup   # installs gems, prepares the database
bin/dev     # starts the dev server on http://localhost:3000
```

The Ruby version is pinned in `.ruby-version`.

## Running checks

```bash
bin/check
```

Runs the same suite as CI: Brakeman, bundler-audit, importmap audit, RuboCop,
and RSpec. `bundle exec rspec` runs the tests alone.

## Contributing

Issues and pull requests are welcome. Before opening a PR:

1. Run `bin/check` and make sure everything passes.
2. Keep changes small and focused — one concern per PR.

See `CLAUDE.md` for the project's coding conventions (service objects,
skinny controllers, standard CRUD actions only, etc.).

## Disclaimer

Ironscores is a fan-made community project. It is not affiliated with or
endorsed by Lost City, 2004scape, or Jagex Ltd. Player data is fetched from
the public Lost City hiscores API and remains the work of that project.

## License

[MIT](LICENSE).
