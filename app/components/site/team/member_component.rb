module Site
  module Team
    class MemberComponent < ViewComponent::Base
      TYPES = %i[elected appointed].freeze

      def initialize(member:, role:, type:)
        @member = member
        @role = role
        @type = type.to_sym
        raise ArgumentError, "unknown team member type: #{type}" unless TYPES.include?(@type)
      end

      private

      attr_reader :member, :role, :type

      def button_data
        Ui::ModalComponent.trigger_data("role-modal", before: "role-modal#populate").merge(
          role: role_name,
          role_type: type,
          member_name: member_name,
          responsibilities: role.fetch(:responsibilities).to_json,
          history: history.to_json,
          application_status: applications.fetch(:status, "closed"),
          application_url: applications[:url]
        )
      end

      def button_classes
        return "p-6 border-3 border-dashed border-brand-gray/30 bg-brand-cream h-full w-full text-left cursor-pointer transition-transform duration-200 hover:-translate-y-1 focus-visible:outline-3 focus-visible:outline-brand-red" if unassigned?

        "card card-link h-full w-full text-left cursor-pointer focus-visible:outline-3 focus-visible:outline-brand-red"
      end

      def button_style
        return if unassigned?

        shadow = type == :elected ? "var(--color-brand-red)" : "var(--color-brand-red-300)"
        "box-shadow: 5px 5px 0px #{shadow};"
      end

      def icon_container_classes
        unassigned? ? "bg-brand-gray/10" : "bg-brand-red/10"
      end

      def icon_classes
        unassigned? ? "w-5 h-5 opacity-40" : "w-5 h-5 text-brand-red"
      end

      def name_classes
        unassigned? ? "text-brand-gray/50 text-sm italic" : "text-sm"
      end

      def role_name = member.fetch(:role)
      def member_name = member[:name] || "Unassigned"
      def unassigned? = member[:name].nil?
      def applications = member.fetch(:applications, {})

      def history
        member[:history] || [ { name: member_name, period: "Present" } ]
      end
    end
  end
end
