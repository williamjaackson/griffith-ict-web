module Site
  module Team
    class GroupComponent < ViewComponent::Base
      MAX_COLUMNS = 4
      COLUMN_CLASSES = {
        1 => "md:grid-cols-1",
        2 => "md:grid-cols-2",
        3 => "md:grid-cols-3",
        4 => "md:grid-cols-4"
      }.freeze
      SETTINGS = {
        elected: {
          label: "ELECTED",
          badge_classes: "badge badge-sm",
          description: "Voted on by members at the Annual General Meeting."
        },
        appointed: {
          label: "APPOINTED",
          badge_classes: "badge badge-dark badge-sm",
          description: "Voted on by the executive team. Applications are opened as needed."
        }
      }.freeze

      def initialize(members:, roles:, type:, separated: false)
        @members = members
        @roles = roles
        @type = type.to_sym
        @settings = SETTINGS.fetch(@type) { raise ArgumentError, "unknown team group type: #{type}" }
        @separated = separated
      end

      def render? = members.any?

      private

      attr_reader :members, :roles, :type, :settings

      def rows
        row_count = (members.length.fdiv(MAX_COLUMNS)).ceil
        minimum_size, larger_rows = members.length.divmod(row_count)
        sizes = Array.new(row_count, minimum_size)
        larger_rows.times { |index| sizes[index] += 1 }

        remaining = members.dup
        sizes.map { |size| remaining.shift(size) }
      end

      def columns_for(row) = COLUMN_CLASSES.fetch(row.length)
      def separated? = @separated
      def label = settings.fetch(:label)
      def badge_classes = settings.fetch(:badge_classes)
      def description = settings.fetch(:description)
    end
  end
end
