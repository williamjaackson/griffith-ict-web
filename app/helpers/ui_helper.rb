module UiHelper
  def ui_button(label, href:, variant:, size: :base, **options)
    render Ui::ButtonComponent.new(label: label, href: href, variant: variant, size: size, **options)
  end

  def ui_heading(text, level: 1, **options)
    render Ui::HeadingComponent.new(text: text, level: level, **options)
  end

  def ui_badge(text, variant: :primary, size: :base, color: nil, **options)
    render Ui::BadgeComponent.new(text: text, variant: variant, size: size, color: color, **options)
  end

  def ui_logo(type: :icon, variant: :black, **options)
    render Ui::LogoComponent.new(type: type, variant: variant, **options)
  end
end
