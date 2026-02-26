module ButtonHelper
  def ui_button(label, href:, variant:, size: :base, **options)
    render partial: "shared/button", locals: {
      label: label,
      href: href,
      variant: variant,
      size: size,
      options: options
    }
  end
end
