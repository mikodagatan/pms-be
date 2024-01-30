# Project Management System - Backend

## Requirements

- Ruby 3.2.1
- Redis 7.2.4
- Postgresql 12.9

## Pushing to Staging

- Have access to Heroku `pms-backend-staging`
- `git remote add staging https://git.heroku.com/pms-backend-staging.git`
- Create a PR to push your changes to the `main` branch, get approval, get success checks, and merge the PR.
- `git pull --rebase origin main`
- `git push staging main`
