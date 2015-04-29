class Calendar < Struct.new(:view, :date, :callback)
  HEADER = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)
  START_DAY = :sunday
  delegate :content_tag, to: :view

  def table
    content_tag :table, class: "calendar" do
      header + week_rows #attach week rows to header
    end
  end

  def header
    content_tag :tr do
      HEADER.map { |day| content_tag :th, day }.join.html_safe
    end
  end

  def week_rows
    weeks.map do |week| #iterates through the weeks in the month
      content_tag :tr do #iterates through the 7 days in the week
        week.map { |day| day_cell(day) }.join.html_safe
      end
    end.join.html_safe
  end

  def day_cell(day)
    content_tag :td, view.capture(day, &callback), class: day_classes(day)
  end

  def day_classes(day)
    classes = []
    classes << "today" if day == Date.today #check if the cell is current day
    classes << "not-month" if day.month != date.month
    classes.empty? ? nil : classes.join(" ")
  end

  def weeks
    first = date.beginning_of_month.beginning_of_week(START_DAY)
    last = date.end_of_month.end_of_week(START_DAY)
    (first..last).to_a.in_groups_of(7) #split the days into arrays of length 7
  end
end