module Ui
  class CardComponent < ViewComponent::Base
    def initialize(href: nil, color: nil, shadow: nil, sidebar: nil, **options)
      @href = href
      @color = color
      @shadow = shadow
      @sidebar = sidebar
      @extra_class = options.delete(:class)
      @options = options
    end

    private

    def tag_name
      @href ? :a : :div
    end

    def classes
      parts = ["border-3 border-brand-black relative overflow-hidden"]
      parts << (@color ? "" : "bg-white")
      if @href
        parts << "transition-all duration-200 hover:-translate-y-1 active:translate-y-0 active:shadow-none"
        parts << "hover:shadow-[5px_5px_0px_var(--card-shadow-color)]" unless @shadow
      end
      parts << @extra_class
      parts.compact.join(" ")
    end

    def style
      styles = []
      styles << "background-color: #{@color};" if @color
      styles << "box-shadow: 5px 5px 0px #{@shadow};" if @shadow
      if @href
        shadow_color = @sidebar || "var(--color-brand-red)"
        styles << "--card-shadow-color: #{shadow_color};"
      end
      styles.join(" ")
    end

    def html_options
      opts = @options.dup
      opts[:href] = @href if @href
      opts
    end
  end
end
