class EventsController < ApplicationController

  def new
  end

  def create
    @event = current_account.teams.events.build(event_params)
    if @event.save
      flash[:success] = 'Event created.'
      redirect_to account_teams_path(current_account)
    else
      flash[:error] = 'Error: Please make sure your event has a title and time.'
      redirect_to account_teams_path(current_account)
    end
  end

  def edit
    @event = current_account.events.find(params[:id])
  end

  def update
    @event = current_account.events.find(params[:id])
    if @event.update_attributes(event_params)
      flash[:success] = 'Updated event.'
      redirect_to calendar_path
    else
      flash[:error] = 'Unable to update event.'
      redirect_to calendar_path
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    flash[:success] = 'Event deleted.'
    redirect_to calendar_path
  end

  private
    def event_params
      params.require(:event).permit(:title, :description, :location, :startdate, :enddate, :starttime, :endtime, :notify, :notifydate)
    end
end
