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
| Database  | SQLite 3                            |
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

## Deployment

Merging to `master` triggers an automatic deploy via GitHub Actions.

