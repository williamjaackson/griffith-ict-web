require "test_helper"
require "tempfile"

class SiteConfigTest < ActiveSupport::TestCase
  test "loads every site configuration with deeply frozen symbol keys" do
    config = SiteConfig.load_all(root: Rails.root.join("config"))

    assert_equal SiteConfig::FILES, config.keys
    assert_equal "Griffith ICT Club", config.dig(:meta, :site_name)
    assert config.frozen?
    assert config[:team].frozen?
    assert config.dig(:team, :campuses).frozen?
  end

  test "rejects aliases and reports the source file" do
    file = Tempfile.new([ "invalid-site-config", ".yml" ])
    file.write("value: &shared test\nalias: *shared\n")
    file.close

    error = assert_raises(SiteConfig::Error) { SiteConfig.load_file(Pathname(file.path)) }

    assert_includes error.message, file.path
  ensure
    file&.unlink
  end

  test "reports missing required settings before the application serves requests" do
    error = assert_raises(SiteConfig::Error) { SiteConfig.validate!(meta: {}) }

    assert_includes error.message, "Missing meta configuration"
    assert_includes error.message, "site_name"
  end
end
