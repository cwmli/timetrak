module CalendarHelper
  def calendar(date = Date.today, &block)
    calendar.new(self, date, block).table
  end
end
