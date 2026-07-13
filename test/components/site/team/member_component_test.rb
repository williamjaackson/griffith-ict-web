require "test_helper"

module Site
  module Team
    class MemberComponentTest < ViewComponent::TestCase
      ROLE = { responsibilities: [ "Lead the club." ] }.freeze

      test "renders assigned members with modal data" do
        member = {
          role: "President",
          name: "Alex Example",
          icon: "crown",
          history: [ { name: "Alex Example", period: "Jan 2026 - Present" } ],
          applications: { status: "open", url: "https://example.com/apply" }
        }

        render_inline(MemberComponent.new(member: member, role: ROLE, type: :elected))
        button = Nokogiri::HTML5.fragment(rendered_content).at_css("button")

        assert_equal "role-modal#populate modal#open", button["data-action"]
        assert_equal "role-modal", button["data-modal-id-param"]
        assert_equal "Alex Example", button["data-member-name"]
        assert_equal [ "Lead the club." ], JSON.parse(button["data-responsibilities"])
        assert_equal "open", button["data-application-status"]
        assert_equal "https://example.com/apply", button["data-application-url"]
        assert_includes button["class"], "shadow-[5px_5px_0px_var(--color-brand-red)]"
      end

      test "renders unassigned members with safe defaults" do
        member = { role: "President", name: nil, icon: "crown" }

        render_inline(MemberComponent.new(member: member, role: ROLE, type: :appointed))
        button = Nokogiri::HTML5.fragment(rendered_content).at_css("button")

        assert_equal "Unassigned", button["data-member-name"]
        assert_equal [ { "name" => "Unassigned", "period" => "Present" } ], JSON.parse(button["data-history"])
        assert_equal "closed", button["data-application-status"]
        assert_nil button["style"]
        assert_includes button["class"], "border-dashed"
      end

      test "rejects unknown member types" do
        assert_raises(ArgumentError) do
          MemberComponent.new(member: {}, role: ROLE, type: :volunteer)
        end
      end
    end
  end
end
