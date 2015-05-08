class CalendarController < ApplicationController
  def show
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @events_by_date = current_account.events.group_by(&:startdate)
    date_range = Date.today..Date.today.end_of_month
    @events = current_account.events.where(startdate: date_range)
    @event = Event.new(:account => @current_account)
  end
end
