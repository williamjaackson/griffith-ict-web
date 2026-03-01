Rails.application.config.socials = YAML.load_file(Rails.root.join("config/socials.yml")).symbolize_keys.freeze
