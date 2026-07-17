module AboutHelper
  def team_rows(members)
    members.each_slice(members.length == 5 ? 3 : 4).to_a
  end

  def team_columns(count)
    { 1 => "md:grid-cols-1", 2 => "md:grid-cols-2", 3 => "md:grid-cols-3", 4 => "md:grid-cols-4" }.fetch(count)
  end

  def role_duration(period)
    starts_on, ends_on = period.split(" - ")
    return unless ends_on

    start_date = Date.strptime(starts_on, "%b %Y")
    end_date = ends_on == "Present" ? Date.current : Date.strptime(ends_on, "%b %Y")
    months = (end_date.year * 12 + end_date.month) - (start_date.year * 12 + start_date.month) + 1
    years, remaining_months = months.divmod(12)

    [
      ("#{years} #{'yr'.pluralize(years)}" if years.positive?),
      ("#{remaining_months} #{'mo'.pluralize(remaining_months)}" if remaining_months.positive?)
    ].compact.join(" ").presence
  rescue Date::Error
    nil
  end
end
