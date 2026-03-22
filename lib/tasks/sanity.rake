namespace :sanity do
  desc "Run content and config sanity checks"
  task check: :environment do
    checks_passed = true

    # Perk count must not be a multiple of 6.
    # The perks grid uses 2/3/5/6 column breakpoints. A multiple of 6 fills the
    # 6-col row but leaves an uneven last row at md:grid-cols-5. When this fires,
    # revisit the grid layout in the perks partial.
    perks = YAML.load_file(Rails.root.join("config/sponsors.yml")).fetch("perks", [])
    perk_count = perks.size

    if perk_count > 0 && (perk_count % 6).zero?
      puts "FAIL: Perk count is #{perk_count} (multiple of 6). Revisit the perks grid layout."
      checks_passed = false
    else
      puts "PASS: Perk count is #{perk_count} (not a multiple of 6)."
    end

    abort "Sanity checks failed." unless checks_passed
  end
end
