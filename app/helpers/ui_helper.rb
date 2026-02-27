module UiHelper
  def ui_button(label, href: nil, variant:, size: :base, **options)
    render Ui::ButtonComponent.new(label: label, href: href, variant: variant, size: size, **options)
  end

  def ui_heading(text, level: 1, **options)
    render Ui::HeadingComponent.new(text: text, level: level, **options)
  end

  def ui_badge(text, variant: :primary, size: :base, color: nil, **options)
    render Ui::BadgeComponent.new(text: text, variant: variant, size: size, color: color, **options)
  end

  def ui_logo(**options)
    render Ui::LogoComponent.new(**options)
  end

  def ui_card(**options, &block)
    render Ui::CardComponent.new(**options), &block
  end

  def ui_navbar
    render Ui::NavbarComponent.new
  end

  def ui_footer
    render Ui::FooterComponent.new
  end
end
