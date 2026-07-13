require "yaml"

module SiteConfig
  FILES = %i[meta socials sponsors sponsorship_tiers team].freeze
  REQUIRED_KEYS = {
    meta: %i[site_name description og_image url member_count established_at],
    socials: %i[discord github linkedin instagram email campus_groups],
    sponsors: %i[sponsors perks],
    sponsorship_tiers: %i[tiers],
    team: %i[campuses roles]
  }.freeze

  class Error < StandardError; end

  module_function

  def load_all(root:)
    config = FILES.to_h do |name|
      [ name, load_file(root.join("#{name}.yml")) ]
    end
    validate!(config)
    config.freeze
  end

  def load_file(path)
    content = YAML.safe_load_file(path, aliases: false) || {}
    deep_freeze(content.deep_symbolize_keys)
  rescue Psych::Exception => error
    raise Error, "Invalid site configuration in #{path}: #{error.message}"
  end

  def validate!(config)
    REQUIRED_KEYS.each do |name, required_keys|
      section = config[name]
      raise Error, "Missing #{name} configuration" unless section.is_a?(Hash)

      missing_keys = required_keys - section.keys
      next if missing_keys.empty?

      raise Error, "Missing #{name} configuration: #{missing_keys.join(', ')}"
    end
  end

  def deep_freeze(value)
    case value
    when Hash
      value.each { |key, item| deep_freeze(key); deep_freeze(item) }
    when Array
      value.each { |item| deep_freeze(item) }
    end

    value.freeze
  end
end
