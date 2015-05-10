class CalendarController < ApplicationController
  def show
    @date = params[:date] ? Date.parse(params[:date]) : Date.today

    @events_by_date = current_account.events.group_by(&:startdate)
    @events_by_date.each do |date, events_on_date_hash| #array of events on that date
      if events_on_date_hash.length > 1 #sort only if there are more than 2 events
        @events_by_date[date] = events_on_date_hash.sort_by { |h| h[:starttime] }
      end
    end

    date_range = Date.today..Date.today.end_of_month
    @events = current_account.events.where(startdate: date_range)
    @events = @events.sort_by { |h| h[:starttime]}

    @event = Event.new(:account => @current_account)
  end
end
