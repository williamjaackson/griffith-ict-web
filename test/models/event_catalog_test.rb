require "test_helper"
require "tmpdir"

class EventCatalogTest < ActiveSupport::TestCase
  setup do
    @root = Pathname(Dir.mktmpdir("event-catalog-test"))
    @events_directory = @root.join("events").tap(&:mkpath)
    @asset_root = @root.join("images").tap(&:mkpath)
    @asset_root.join("poster.png").write("poster")
  end

  teardown do
    FileUtils.remove_entry(@root)
  end

  test "loads, publishes, and orders events" do
    write_event("later.yml", base_event.merge("slug" => "later", "starts_at" => "2026-09-01T10:00:00+10:00", "ends_at" => "2026-09-01T12:00:00+10:00"))
    write_event("sooner.yml", base_event.merge("slug" => "sooner"))
    write_event("draft.yml", base_event.merge("slug" => "draft", "published" => false))

    catalog = build_catalog

    assert_equal %w[draft later sooner], catalog.all.map(&:slug).sort
    assert_equal %w[later sooner], catalog.published.map(&:slug).sort
    assert_equal %w[sooner later], catalog.upcoming(at: Time.iso8601("2026-07-13T00:00:00+10:00")).map(&:slug)
  end

  test "classifies ongoing events as upcoming and completed events as past" do
    write_event("past.yml", base_event.merge("slug" => "past", "starts_at" => "2026-07-01T10:00:00+10:00", "ends_at" => "2026-07-01T12:00:00+10:00"))
    write_event("ongoing.yml", base_event.merge("slug" => "ongoing", "starts_at" => "2026-07-13T10:00:00+10:00", "ends_at" => "2026-07-13T17:00:00+10:00"))
    write_event("future.yml", base_event.merge("slug" => "future"))
    at = Time.iso8601("2026-07-13T12:00:00+10:00")
    catalog = build_catalog

    assert_equal %w[ongoing future], catalog.upcoming(at: at).map(&:slug)
    assert_equal [ "past" ], catalog.past(at: at).map(&:slug)
    assert catalog.find("ongoing").happening_now?(at: at)
  end

  test "rejects duplicate slugs" do
    write_event("one.yml", base_event)
    write_event("two.yml", base_event)

    error = assert_raises(EventCatalog::InvalidEvent) { build_catalog.all }
    assert_includes error.message, "duplicate event slug"
    assert_includes error.message, "one.yml"
    assert_includes error.message, "two.yml"
  end

  test "rejects invalid and reversed timestamps" do
    write_event("invalid.yml", base_event.merge("starts_at" => "not-a-date"))
    error = assert_raises(EventCatalog::InvalidEvent) { build_catalog.all }
    assert_includes error.message, "starts_at must be an ISO-8601 timestamp"

    @events_directory.children.each(&:delete)
    write_event("reversed.yml", base_event.merge("ends_at" => "2026-07-31T10:00:00+10:00"))
    error = assert_raises(EventCatalog::InvalidEvent) { build_catalog.all }
    assert_includes error.message, "ends_at must be after starts_at"
  end

  test "rejects YAML aliases and arbitrary objects" do
    @events_directory.join("unsafe.yml").write("defaults: &defaults\n  title: Unsafe\nevent:\n  <<: *defaults\n")

    error = assert_raises(EventCatalog::InvalidEvent) { build_catalog.all }
    assert_includes error.message, "invalid YAML"

    @events_directory.children.each(&:delete)
    @events_directory.join("object.yml").write("--- !ruby/object:Object {}\n")
    error = assert_raises(EventCatalog::InvalidEvent) { build_catalog.all }
    assert_includes error.message, "invalid YAML"
  end

  test "rejects missing artwork" do
    write_event("missing.yml", base_event.merge("image" => "missing.png"))

    error = assert_raises(EventCatalog::InvalidEvent) { build_catalog.all }
    assert_includes error.message, "image does not exist"
  end

  test "requires an HTTPS URL for available tickets" do
    event = base_event.deep_merge("admission" => { "state" => "available", "url" => nil })
    write_event("tickets.yml", event)
    error = assert_raises(EventCatalog::InvalidEvent) { build_catalog.all }
    assert_includes error.message, "admission.url is required"

    @events_directory.children.each(&:delete)
    event = base_event.deep_merge("admission" => { "state" => "available", "url" => "http://example.com/tickets" })
    write_event("tickets.yml", event)
    error = assert_raises(EventCatalog::InvalidEvent) { build_catalog.all }
    assert_includes error.message, "admission.url must be an HTTPS URL"
  end

  test "validates the RSVP state" do
    event = base_event.deep_merge("admission" => { "rsvp_state" => "maybe" })
    write_event("rsvp.yml", event)

    error = assert_raises(EventCatalog::InvalidEvent) { build_catalog.all }
    assert_includes error.message, "admission.rsvp_state must be one of"
  end

  test "requires reviewed items for published terms" do
    event = base_event.deep_merge("terms" => { "state" => "published", "items" => [] })
    write_event("terms.yml", event)

    error = assert_raises(EventCatalog::InvalidEvent) { build_catalog.all }
    assert_includes error.message, "terms.items must contain reviewed terms"
  end

  private

  def build_catalog
    EventCatalog.new(directory: @events_directory, asset_root: @asset_root)
  end

  def write_event(filename, event)
    @events_directory.join(filename).write(event.to_yaml)
  end

  def base_event
    {
      "slug" => "example-event",
      "title" => "Example Event",
      "summary" => "A useful summary.",
      "description" => [ "A useful description." ],
      "published" => true,
      "starts_at" => "2026-08-01T10:00:00+10:00",
      "ends_at" => "2026-08-01T17:00:00+10:00",
      "timezone" => "Australia/Brisbane",
      "image" => "poster.png",
      "image_alt" => "Example event poster",
      "location" => {
        "region" => "Gold Coast",
        "venue" => nil,
        "address" => nil,
        "venue_tba" => true
      },
      "admission" => {
        "state" => "coming_soon",
        "rsvp_state" => "available",
        "url" => nil,
        "price_cents" => 500,
        "currency" => "AUD",
        "members_only" => true,
        "membership_free" => true
      },
      "details" => {
        "team_size" => "2–4 people",
        "inclusions" => [ "Lunch provided" ]
      },
      "prizes" => [ { "place" => "1st", "award" => "$100" } ],
      "terms" => { "state" => "coming_soon", "items" => [] }
    }
  end
end
