# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Start development server
bin/rails server

# Run all tests
bin/rails test

# Run a single test file
bin/rails test test/controllers/events_controller_test.rb

# Run a single test by line number
bin/rails test test/models/event_test.rb:5

# Lint (RuboCop with rails-omakase style)
bin/rubocop

# Security scan
bin/brakeman

# Database setup
bin/rails db:create db:migrate db:seed

# Open Rails console
bin/rails console
```

## Architecture

**Rails 7.2 app (Ruby 3.1.7) with PostgreSQL.** No Node.js — assets are served via Sprockets with importmap (no webpack/bundler).

### Pages and routing

Most pages are purely static views under `StaticController` — no model queries, just ERB templates. The nav has four public pages: Home (`/`), Food & Beverage Menu (`/boba_tea_menu`), Gallery (`/gallery`), About (`/all_about_sip`).

`/dashboard_home` is the only auth-gated page (`before_action :require_login`).

### Events calendar

`EventsController#feed` (`GET /events_feed`) is a server-side proxy: it fetches a Google Calendar ICS feed, parses it with the `icalendar` gem, and returns JSON for the frontend. The ICS URL is loaded from (in priority order): `ENV["GOOGLE_ICS_URL"]` → `Rails.application.credentials.google_ics_url` → `Rails.application.credentials.dig(:google, :ics_url)`.

The `events` database table exists but is unused — the live calendar data comes entirely from the Google Calendar feed.

### Authentication

[Clearance](https://github.com/thoughtbot/clearance) handles auth. The `users` table follows Clearance's schema. Sign-in/password routes are mounted but the nav links are currently commented out — the dashboard is accessible only by direct URL.

### Styling

Single SCSS file at `app/assets/stylesheets/application.scss`. Imports Bootstrap 5.3 and Font Awesome 6. Brand colors: dark navy `#070125` (navbar/body), green `#6FB447` (accent), and a Pokédex-red `#e00022` used for the events calendar widget. Custom font: Rubik Dirt (loaded from Google Fonts) for headings, nav links, and `.title` / `.subtitle` / `.card-title` elements.

The events page uses FullCalendar (loaded via CDN in the events view) with a custom Pokédex-themed skin defined in the SCSS.

### SEO / meta tags

Per-page `<title>` and `<meta>` tags are handled inline in `app/views/layouts/application.html.erb` via `params[:action]` conditionals. Google Analytics (gtag) is injected in non-development/test environments.
