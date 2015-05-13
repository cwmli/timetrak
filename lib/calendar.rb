class Calendar < Struct.new(:view, :date, :callback)
  HEADER = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)
  START_DAY = :sunday
  delegate :content_tag, to: :view

  def table
    content_tag :div, class: "calendar" do #table
      header + week_rows #attach week rows to header
    end
  end

  def header
    content_tag :div, class: "calendar-row" do #table-row
      HEADER.map { |day| content_tag(:div, day, class: "calendar-header") }.join.html_safe #table-header
    end
  end

  def week_rows
    weeks.map do |week|
      content_tag :div, class: "calendar-row" do
        week.map { |day| day_cell(day) }.join.html_safe
      end
    end.join.html_safe
  end

  def day_cell(day) #table-cell
    content_tag :div,  view.capture(day, &callback), class: day_classes(day)
  end

  def day_classes(day)
    classes = []
    classes << "calendar-cell today" if day == Date.today #check if the cell is current day
    classes << "calendar-cell not-month" if day.month != date.month
    classes.empty? ? "calendar-cell" : classes.join(" ")
  end

  def weeks
    first = date.beginning_of_month.beginning_of_week(START_DAY)
    last = date.end_of_month.end_of_week(START_DAY)
    (first..last).to_a.in_groups_of(7) #split the days into arrays of length 7
  end
end
