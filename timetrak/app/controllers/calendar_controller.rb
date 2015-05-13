class CalendarController < ApplicationController
  def show
    @date = params[:date] ? Date.parse(params[:date]) : Date.today

    if current_account.teams.empty? #fetch team events only if a team exists
      @events_by_date = current_account.teams.find_by(id: selected_team).events.group_by(&:startdate)
      @events_by_date.each do |date, events_on_date_hash| #array of events on that date
        if events_on_date_hash.length > 1 #sort only if there are more than 2 events
          @events_by_date[date] = events_on_date_hash.sort_by { |h| h[:starttime] }
        end
      end

      date_range = Date.today..Date.today.end_of_month
      @events = current_account.teams.find_by(id: selected_team).events.where(startdate: date_range)
      @events = @events.sort_by { |h| h[:starttime]}
    end

    @event = Event.new(:team => params)
  end
end
