Rails.application.config.socials = YAML.load_file(Rails.root.join("config/socials.yml")).deep_symbolize_keys.freeze
