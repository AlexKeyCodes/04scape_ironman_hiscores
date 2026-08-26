# Admin can sign in and out (username + password, cookie session)

**Branch:** `auth`
**Started:** 2026-08-25

Plan: username login, `session[:user_id]` cookie storage, no email anywhere.

## Sub-tasks

### User model
- [ ] Uncomment bcrypt in Gemfile
- [ ] Migration: users (username unique, password_digest, role — all null: false)
- [ ] User model: has_secure_password, role enum (admin: 0), normalized username
- [ ] Model specs

### Authentication concern
- [ ] current_user / authenticated? helpers
- [ ] require_authentication (opt-in before_action, stores return_to)
- [ ] start_new_session_for / terminate_session (reset_session first)
- [ ] Request spec via test-only controller

### Sessions controller
- [ ] resource :session routes + temporary root "sessions#new"
- [ ] new / create (authenticate_by) / destroy
- [ ] Login form view + flash in layout
- [ ] Request specs (success, bad password, unknown user, logout)
- [ ] System spec: login/logout flow

### Wrap-up
- [ ] CLAUDE.md: console admin creation snippet
- [ ] bin/check green
- [ ] TODO.md → Done, delete this file, merge to main
