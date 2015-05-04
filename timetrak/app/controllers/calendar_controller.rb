class CalendarController < ApplicationController
  def show
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @events = current_account.events
    @account = current_account
    @event = Event.new(:account => @account)
  end
end
