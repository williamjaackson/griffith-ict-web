# Griffith ICT Club

**Build. Learn. Connect.**

The official website for Griffith University's student-run tech club.

https://griffithict.club/

---

## Tech Stack

| Layer     | Technology                          |
| --------- | ----------------------------------- |
| Framework | Ruby on Rails 8                     |
| Ruby      | 3.4.10                              |
| Styling   | Tailwind CSS                        |
| UI        | ViewComponent, Stimulus, Lucide     |
| Assets    | Propshaft, Importmap                |
| Database  | SQLite 3 (local/test), PostgreSQL (deployed) |
| Server    | Puma                                |
| Deploy    | GitHub Actions → VPS via SSH        |

## Getting Started

**Prerequisites:** Ruby 3.4.10 (see `.ruby-version`)

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

## Reusable modals

Render `Ui::ModalComponent` once and give it a unique ID and accessible name:

```erb
<%= render Ui::ModalComponent.new(id: "example-modal", title: "Example") do %>
  Modal content
<% end %>
```

Any button can open it through the shared controller. The component helper keeps
the Stimulus action and modal ID consistent:

```erb
<%= button_tag "Open", type: "button",
      data: Ui::ModalComponent.trigger_data("example-modal") %>
```

The shared component handles the backdrop, close button, Escape key, focus trap,
focus restoration, scroll locking, and ARIA state. A feature-specific Stimulus
controller only needs to populate or update its modal's content.

### Databases

Local development and automated tests use SQLite, so no database service or
credentials are needed to run the app locally.

Production and VPS previews use Neon PostgreSQL. Each deployed environment
requires these variables in its protected `.env` file:

- `DATABASE_URL` — the pooled Neon connection string used by Puma.
- `DIRECT_DATABASE_URL` — the matching direct connection string used only for
  migrations and seeds.
- `ADMIN_PASSWORD` — used only while seeding the administrator account.
- `SECRET_KEY_BASE` — generated with `bin/rails secret` and used to sign runtime
  data. An existing `RAILS_MASTER_KEY` may provide this value through encrypted
  credentials instead.

Do not commit any of these values. Copy `.env.example` only when configuring a deployed
environment. Store production values in `~/griffith-ict-web/.env` and preview
values in `/opt/previews/.env`, keep the values shell-quoted because the URLs
contain `&`, then restrict each file with `chmod 600`.

All preview sites share the preview database. Migrations deployed to previews
must therefore remain backward-compatible with other preview branches, and
preview teardown never reverses database migrations.

Deployments generate a separate `.env.runtime` file containing only the values
the web process needs. The direct database URL and seed password are therefore
not exposed to the long-running Puma service.

## Deployment

Merging to `master` triggers an automatic deploy via GitHub Actions.

Configure these repository Actions secrets before deploying:

- `VPS_HOST` — the VPS hostname or IP address.
- `VPS_SSH_KEY` — the private key for the deployment account.
- `VPS_SSH_KNOWN_HOSTS` — the VPS host-key line captured with `ssh-keyscan -H`
  after verifying its fingerprint through a trusted channel.

Deploy and preview workflows check out the exact commit from the GitHub event,
run migrations and assets once, restart the corresponding systemd service, and
wait for `/up` to return successfully. Concurrent production deploys are
serialized. Preview deploys are restricted to branches in this repository.

Before the first PostgreSQL deploy, back up `storage/production.sqlite3`, rotate
the Neon owner passwords, and place the new pooled and direct URLs in the VPS
environment files. The VPS connects outbound to Neon; it does not run a local
PostgreSQL server.
