require "test_helper"

module Site
  module Team
    class GroupComponentTest < ViewComponent::TestCase
      test "balances members across rows of at most four" do
        members = 6.times.map do |index|
          { role: "President", name: "Member #{index}", icon: "crown" }
        end
        component = GroupComponent.new(
          members: members,
          roles: { President: { responsibilities: [] } },
          type: :elected
        )

        assert_equal [ 3, 3 ], component.send(:rows).map(&:length)

        render_inline(component)

        assert_equal 6, Nokogiri::HTML5.fragment(rendered_content).css("button[data-role=President]").length
      end

      test "does not render empty groups" do
        render_inline(GroupComponent.new(members: [], roles: {}, type: :appointed))

        assert_empty rendered_content
      end
    end
  end
end
