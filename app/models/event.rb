class Event
  TICKET_STATES = %w[coming_soon available sold_out closed].freeze
  TERMS_STATES = %w[coming_soon published].freeze

  attr_reader :slug, :title, :summary, :description, :starts_at, :ends_at,
    :timezone, :image, :image_alt, :location, :admission, :details, :prizes,
    :terms, :source

  def initialize(attributes:, source:, asset_root: Rails.root.join("app/assets/images"))
    @source = source.to_s
    @asset_root = Pathname(asset_root)
    validate_root!(attributes)

    @slug = string!(attributes, "slug")
    @title = string!(attributes, "title")
    @summary = string!(attributes, "summary")
    @description = string_array!(attributes, "description")
    @published = boolean!(attributes, "published")
    @timezone = string!(attributes, "timezone")
    validate_timezone!
    @starts_at = time!(attributes, "starts_at")
    @ends_at = time!(attributes, "ends_at")
    error!("ends_at must be after starts_at") unless ends_at > starts_at

    @image = string!(attributes, "image")
    @image_alt = string!(attributes, "image_alt")
    validate_asset!
    @location = location!(hash!(attributes, "location"))
    @admission = admission!(hash!(attributes, "admission"))
    @details = details!(hash!(attributes, "details"))
    @prizes = prizes!(array!(attributes, "prizes"))
    @terms = terms!(hash!(attributes, "terms"))
    validate_slug!
  end

  def published? = @published

  def upcoming?(at: Time.current) = ends_at > at
  def past?(at: Time.current) = !upcoming?(at: at)
  def happening_now?(at: Time.current) = starts_at <= at && ends_at > at

  def status(at: Time.current)
    return :past if past?(at: at)
    return :happening_now if happening_now?(at: at)

    :upcoming
  end

  def ticket_state(at: Time.current)
    past?(at: at) ? "closed" : admission.fetch("state")
  end

  def local_starts_at = starts_at.in_time_zone(timezone)
  def local_ends_at = ends_at.in_time_zone(timezone)

  private

  def validate_root!(attributes)
    error!("event must be a mapping") unless attributes.is_a?(Hash)
  end

  def validate_slug!
    error!("slug must use lowercase letters, numbers, and hyphens") unless slug.match?(/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/)
  end

  def validate_timezone!
    TZInfo::Timezone.get(timezone)
  rescue TZInfo::InvalidTimezoneIdentifier
    error!("timezone is not valid")
  end

  def validate_asset!
    path = @asset_root.join(image).cleanpath
    root = @asset_root.cleanpath.to_s
    error!("image must be inside app/assets/images") unless path.to_s.start_with?("#{root}/")
    error!("image does not exist: #{image}") unless path.file?
  end

  def location!(value)
    region = string!(value, "region", prefix: "location")
    venue_tba = boolean!(value, "venue_tba", prefix: "location")
    venue = optional_string!(value, "venue", prefix: "location")
    address = optional_string!(value, "address", prefix: "location")
    error!("location.venue is required when venue_tba is false") if !venue_tba && venue.nil?

    { "region" => region, "venue" => venue, "address" => address, "venue_tba" => venue_tba }.freeze
  end

  def admission!(value)
    state = string!(value, "state", prefix: "admission")
    error!("admission.state must be one of: #{TICKET_STATES.join(', ')}") unless TICKET_STATES.include?(state)
    url = optional_string!(value, "url", prefix: "admission")
    validate_https_url!(url, "admission.url") if url
    error!("admission.url is required when tickets are available") if state == "available" && url.nil?

    price_cents = integer!(value, "price_cents", prefix: "admission")
    error!("admission.price_cents cannot be negative") if price_cents.negative?
    currency = string!(value, "currency", prefix: "admission")
    error!("admission.currency must be a three-letter code") unless currency.match?(/\A[A-Z]{3}\z/)

    {
      "state" => state,
      "url" => url,
      "price_cents" => price_cents,
      "currency" => currency,
      "members_only" => boolean!(value, "members_only", prefix: "admission"),
      "membership_free" => boolean!(value, "membership_free", prefix: "admission")
    }.freeze
  end

  def details!(value)
    {
      "team_size" => string!(value, "team_size", prefix: "details"),
      "inclusions" => string_array!(value, "inclusions", prefix: "details")
    }.freeze
  end

  def prizes!(values)
    values.map.with_index do |value, index|
      error!("prizes[#{index}] must be a mapping") unless value.is_a?(Hash)
      {
        "place" => string!(value, "place", prefix: "prizes[#{index}]"),
        "award" => string!(value, "award", prefix: "prizes[#{index}]")
      }.freeze
    end.freeze
  end

  def terms!(value)
    state = string!(value, "state", prefix: "terms")
    error!("terms.state must be one of: #{TERMS_STATES.join(', ')}") unless TERMS_STATES.include?(state)
    items = string_array!(value, "items", prefix: "terms")
    error!("terms.items must contain reviewed terms when published") if state == "published" && items.empty?
    { "state" => state, "items" => items }.freeze
  end

  def validate_https_url!(value, field)
    uri = URI.parse(value)
    error!("#{field} must be an HTTPS URL") unless uri.is_a?(URI::HTTPS) && uri.host.present?
  rescue URI::InvalidURIError
    error!("#{field} must be an HTTPS URL")
  end

  def hash!(hash, key, prefix: nil)
    value = fetch!(hash, key, prefix: prefix)
    error!("#{field_name(prefix, key)} must be a mapping") unless value.is_a?(Hash)
    value
  end

  def array!(hash, key, prefix: nil)
    value = fetch!(hash, key, prefix: prefix)
    error!("#{field_name(prefix, key)} must be a list") unless value.is_a?(Array)
    value
  end

  def string!(hash, key, prefix: nil)
    value = fetch!(hash, key, prefix: prefix)
    error!("#{field_name(prefix, key)} must be a non-empty string") unless value.is_a?(String) && value.present?
    value
  end

  def optional_string!(hash, key, prefix: nil)
    value = hash[key]
    return nil if value.nil?
    error!("#{field_name(prefix, key)} must be a non-empty string or null") unless value.is_a?(String) && value.present?
    value
  end

  def string_array!(hash, key, prefix: nil)
    value = array!(hash, key, prefix: prefix)
    error!("#{field_name(prefix, key)} must contain only non-empty strings") unless value.all? { |item| item.is_a?(String) && item.present? }
    value.freeze
  end

  def boolean!(hash, key, prefix: nil)
    value = fetch!(hash, key, prefix: prefix)
    error!("#{field_name(prefix, key)} must be true or false") unless value == true || value == false
    value
  end

  def integer!(hash, key, prefix: nil)
    value = fetch!(hash, key, prefix: prefix)
    error!("#{field_name(prefix, key)} must be an integer") unless value.is_a?(Integer)
    value
  end

  def time!(hash, key)
    value = string!(hash, key)
    Time.iso8601(value)
  rescue ArgumentError
    error!("#{key} must be an ISO-8601 timestamp")
  end

  def fetch!(hash, key, prefix: nil)
    error!("#{field_name(prefix, key)} is required") unless hash.key?(key)
    hash[key]
  end

  def field_name(prefix, key) = [prefix, key].compact.join(".")

  def error!(message)
    raise EventCatalog::InvalidEvent, "#{source}: #{message}"
  end
end
