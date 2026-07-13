require "test_helper"

class PublicErrorPagesTest < ActiveSupport::TestCase
  ERROR_PAGES = %w[400.html 404.html 406-unsupported-browser.html 422.html 500.html].freeze

  test "static error pages share accessible, policy-friendly assets" do
    ERROR_PAGES.each do |filename|
      document = Nokogiri::HTML5(File.read(Rails.root.join("public", filename)))

      assert document.at_css("html[lang=en]"), filename
      assert document.at_css("meta[name=robots][content='noindex, nofollow']"), filename
      assert document.at_css("h1.badge"), filename
      assert document.at_css("link[href='/error.css']"), filename
      assert document.at_css("script[src='/error.js'][defer]"), filename
      assert_empty document.css("style, script:not([src]), [style]"), filename
    end
  end

  test "shared error assets support reduced motion and contextual reports" do
    stylesheet = Rails.root.join("public/error.css").read
    javascript = Rails.root.join("public/error.js").read

    assert_includes stylesheet, "prefers-reduced-motion: reduce"
    assert_includes javascript, "data-report-error"
    assert_includes javascript, "location.href"
    assert_not_includes javascript, "innerHTML"
  end
end
