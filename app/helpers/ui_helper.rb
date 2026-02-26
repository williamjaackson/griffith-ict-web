module UiHelper
  def ui_button(label, href:, variant:, size: :base, **options)
    render Ui::ButtonComponent.new(label: label, href: href, variant: variant, size: size, **options)
  end
end
