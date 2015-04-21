class CalendarController < ApplicationController
  helper CalendarHelper

  def show
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end
end
