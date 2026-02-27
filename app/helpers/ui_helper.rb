module UiHelper
  def ui_button(label, href:, variant:, size: :base, **options)
    render Ui::ButtonComponent.new(label: label, href: href, variant: variant, size: size, **options)
  end

  def ui_heading(text, level: 1, **options)
    render Ui::HeadingComponent.new(text: text, level: level, **options)
  end
end
