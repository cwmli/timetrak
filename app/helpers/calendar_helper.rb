module CalendarHelper
  def calendar(date = Date.today, &block)
    Calendar.new(self, date, block).table
  end

  @@current_team = nil

  def current_team
    @@current_team #allow current season to be accessed as 'current_season' in controller views
  end
end
