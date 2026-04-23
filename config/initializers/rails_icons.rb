RailsIcons.configure do |config|
  config.default_library = "lucide"

  config.libraries.lucide.outline.default.css = "w-5 h-5"
  config.libraries.lucide.outline.default.stroke_width = "2"

  config.libraries.merge!(
    brands: {
      default: {
        css: "w-5 h-5"
      }
    }
  )
end
