require "test_helper"

class IconConfigurationTest < ActiveSupport::TestCase
  LUCIDE_ICONS = %w[
    arrow-left arrow-right briefcase calendar check chevron-down code crown
    external-link file-text map-pin megaphone monitor settings shield smile
    trophy users wallet x
  ].freeze
  BRAND_ICONS = %w[discord github instagram linkedin].freeze

  test "inline icon sources stay outside the public asset pipeline" do
    icon_path = Pathname(RailsIcons.configuration.icons_path)
    asset_paths = Rails.application.config.assets.paths.map { |path| Pathname(path) }

    assert_equal Rails.root.join("vendor/icons"), icon_path
    assert icon_path.join("lucide/outline/x.svg").file?
    assert asset_paths.none? { |path| icon_path.to_s.start_with?(path.to_s) }
  end

  test "only application icons are vendored" do
    icon_path = Pathname(RailsIcons.configuration.icons_path)
    lucide_icons = icon_path.glob("lucide/outline/*.svg").map(&:basename).map { |name| name.sub_ext("").to_s }
    brand_icons = icon_path.glob("brands/*.svg").map(&:basename).map { |name| name.sub_ext("").to_s }

    assert_equal LUCIDE_ICONS.sort, lucide_icons.sort
    assert_equal BRAND_ICONS.sort, brand_icons.sort
  end
end
