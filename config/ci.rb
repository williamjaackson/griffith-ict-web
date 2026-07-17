# Run using bin/ci

CI.run do
  step "Setup", "bin/setup --skip-server"

  step "Code: Style", "bin/rubocop"
  step "Code: Zeitwerk", "bin/rails zeitwerk:check"
  step "Tests: Rails", "bin/rails test"
  step "Tests: System", "bin/rails test:system"
  step "Tests: Seeds", "env RAILS_ENV=test bin/rails db:seed:replant"
  step "Assets: Precompile", "env RAILS_ENV=test bin/rails assets:precompile"
end
