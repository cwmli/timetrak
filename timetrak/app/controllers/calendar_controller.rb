class CalendarController < ApplicationController
  def show
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @events = current_account.events.all
    @account = current_account
    @event = @account.events.build
  end
end
