module Ui
  class StepsComponentPreview < ViewComponent::Preview
    # Steps communicate progress through a short, linear task such as a multi-step dialog.
    # @param current select { choices: [1, 2] }
    def playground(current: "1")
      render Ui::StepsComponent.new(labels: [ "Join Discord", "Register" ], current: current.to_i)
    end

    def first_step
      render Ui::StepsComponent.new(labels: [ "Join Discord", "Register" ])
    end

    def second_step
      render Ui::StepsComponent.new(labels: [ "Join Discord", "Register" ], current: 2)
    end
  end
end
