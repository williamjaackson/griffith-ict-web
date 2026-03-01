Rails.application.config.meta = YAML.load_file(Rails.root.join("config/meta.yml")).deep_symbolize_keys.freeze
