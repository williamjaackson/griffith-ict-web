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

  def ui_input(label:, **options, &block)
    render Ui::InputComponent.new(label: label, **options), &block
  end

  def ui_input_classes
    Ui::InputComponent::INPUT_CLASSES
  end

  def ui_button_classes(variant: :primary, size: :base)
    [
      Ui::ButtonComponent::BASE_CLASSES,
      Ui::ButtonComponent::VARIANT_CLASSES[variant],
      Ui::ButtonComponent::SIZE_CLASSES[size],
      Ui::ButtonComponent::SHADOW_CLASSES[variant]
    ].join(" ")
  end

  def ui_button_style
    "font-family: 'Unbounded', sans-serif; font-weight: 600;"
  end

  def ui_select(name:, options:, selected: nil, label: nil)
    render Ui::SelectComponent.new(name: name, options: options, selected: selected, label: label)
  end

  def ui_modal(title: nil, **options, &block)
    render Ui::ModalComponent.new(title: title, **options), &block
  end
end
