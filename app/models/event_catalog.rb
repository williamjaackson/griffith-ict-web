class EventCatalog
  class InvalidEvent < StandardError; end

  attr_reader :directory, :asset_root

  def self.all = catalog.all
  def self.published = catalog.published
  def self.upcoming(at: Time.current) = catalog.upcoming(at: at)
  def self.past(at: Time.current) = catalog.past(at: at)
  def self.find(slug) = catalog.find(slug)

  def self.reload!
    @catalog = nil
  end

  def self.catalog
    @catalog ||= new
  end

  def initialize(directory: Rails.root.join("config/events"), asset_root: Rails.root.join("app/assets/images"))
    @directory = Pathname(directory)
    @asset_root = Pathname(asset_root)
  end

  def all
    @all ||= load_events.freeze
  end

  def published
    all.select(&:published?).freeze
  end

  def upcoming(at: Time.current)
    published.select { |event| event.upcoming?(at: at) }.sort_by(&:starts_at).freeze
  end

  def past(at: Time.current)
    published.select { |event| event.past?(at: at) }.sort_by(&:starts_at).reverse.freeze
  end

  def find(slug)
    published.find { |event| event.slug == slug }
  end

  private

  def load_events
    events = directory.glob("*.yml").sort.map { |path| load_event(path) }
    duplicate = events.group_by(&:slug).find { |_slug, matches| matches.many? }
    if duplicate
      slug, matches = duplicate
      raise InvalidEvent, "duplicate event slug #{slug}: #{matches.map(&:source).join(', ')}"
    end
    events
  end

  def load_event(path)
    attributes = YAML.safe_load_file(path, permitted_classes: [], permitted_symbols: [], aliases: false)
    Event.new(attributes: attributes, source: path, asset_root: asset_root)
  rescue Psych::Exception => error
    raise InvalidEvent, "#{path}: invalid YAML (#{error.message})"
  end
end
