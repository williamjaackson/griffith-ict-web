# Griffith ICT Club

**Build. Learn. Connect.**

The official website for Griffith University's student-run tech club.

https://griffithict.club/

---

## Tech Stack

| Layer     | Technology                          |
| --------- | ----------------------------------- |
| Framework | Ruby on Rails 8                     |
| Ruby      | 3.4.1                               |
| Styling   | Tailwind CSS                        |
| UI        | ViewComponent, Stimulus, Lucide     |
| Assets    | Propshaft, Importmap                |
| Database  | SQLite 3 (local/test), PostgreSQL (deployed) |
| Server    | Puma                                |
| Deploy    | GitHub Actions → VPS via SSH        |

## Getting Started

**Prerequisites:** Ruby 3.4.1 (see `.ruby-version`)

```bash
# Install dependencies
bundle install

# Set up the database
rails db:prepare

# Start the dev server (app + Tailwind watcher)
bin/dev
```

The site will be available at `http://localhost:3000`.

## Project Structure

```
app/
├── components/           # ViewComponent UI components
│   ├── ui/               # Reusable primitives (Button, Card, etc.)
│   └── site/             # Site-wide components (Navbar, Footer)
├── javascript/
│   └── controllers/      # Stimulus controllers
└── views/
    └── pages/            # Page templates
        ├── landing/      # Home page sections
        ├── about/        # Team & leadership
        └── sponsorship/  # Sponsorship tiers

config/
├── events/               # One validated YAML file per public event
├── meta.yml              # Site metadata & SEO
├── team.yml              # Leadership by campus
├── socials.yml           # Social media links
├── sponsors.yml          # Sponsor listing
└── sponsorship_tiers.yml # Sponsorship tier definitions
```

## Configuration

Site content is driven by YAML files in `config/`:

- **`meta.yml`** — Site name, description, OG image, member count
- **`team.yml`** — Leadership team members for each campus
- **`socials.yml`** — Discord, GitHub, LinkedIn, Instagram links
- **`sponsors.yml`** — Current sponsors
- **`sponsorship_tiers.yml`** — Sponsorship tier names, prices, and perks

### Events

Public events are managed in Git rather than the database. Add one file per
event at `config/events/<slug>.yml` and place its artwork under
`app/assets/images/events/`. Use the existing Hackathon file as the canonical
example for the required identity, timing, location, admission, details,
prizes, and terms fields.

Times must be quoted ISO-8601 values with an explicit offset and a valid IANA
timezone. An available ticket must have an HTTPS URL; published terms must have
at least one reviewed item. Event text is rendered as plain structured content,
so YAML must not contain HTML or Markdown intended for rendering.

Set `admission.rsvp_state` to `available` to show the internal RSVP form or
`closed` to hide it. RSVPs are stored in `event_rsvps` with the event slug, name,
student number, membership confirmation, derived Griffith student email, and
timestamps. Submission does not send an automated email. Records can be reviewed from the Rails console with
`EventRsvp.where(event_slug: "<slug>")`.

The catalog is validated while Rails boots. Invalid YAML, duplicate slugs,
invalid dates or states, and missing artwork stop boot and CI with the source
file and field. An event stays upcoming through its end time, then moves into
the permanent past-events archive automatically.

### Databases

Local development and automated tests use SQLite, so no database service or
credentials are needed to run the app locally.

Production and VPS previews use Neon PostgreSQL. Each deployed environment
requires two variables in its protected `.env` file:

- `DATABASE_URL` — the pooled Neon connection string used by Puma.
- `DIRECT_DATABASE_URL` — the matching direct connection string used only for
  migrations and seeds.

Do not commit either value. Copy `.env.example` only when configuring a deployed
environment. Store production values in `~/griffith-ict-web/.env` and preview
values in `/opt/previews/.env`, keep the values shell-quoted because the URLs
contain `&`, then restrict each file with `chmod 600`.

All preview sites share the preview database. Migrations deployed to previews
must therefore remain backward-compatible with other preview branches, and
preview teardown never reverses database migrations.

## Deployment

Merging to `master` triggers an automatic deploy via GitHub Actions.

Before the first PostgreSQL deploy, back up `storage/production.sqlite3`, rotate
the Neon owner passwords, and place the new pooled and direct URLs in the VPS
environment files. The VPS connects outbound to Neon; it does not run a local
PostgreSQL server.
