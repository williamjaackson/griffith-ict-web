source "https://rubygems.org"

gem "rails", "~> 8.1.2"
gem "propshaft"
gem "pg", "~> 1.6"
gem "puma", ">= 5.0"
gem "bcrypt", "~> 3.1.7"

gem "tailwindcss-rails"
gem "view_component"
gem "rails_icons"

gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "sqlite3", ">= 2.1"
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "dotenv-rails"
  gem "rubocop-rails-omakase", require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

gem "importmap-rails", "~> 2.2"
gem "stimulus-rails", "~> 1.3"
