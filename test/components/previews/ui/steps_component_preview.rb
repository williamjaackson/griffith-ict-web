module Ui
  class StepsComponentPreview < ViewComponent::Preview
    def first_step
      render StepsComponent.new(labels: [ "Join Discord", "Register" ])
    end

    def second_step
      render StepsComponent.new(labels: [ "Join Discord", "Register" ], current: 2)
    end
  end
end
