class EventsController < ApplicationController

  def new
  end

  def create
    @event = current_account.events.build(event_params)
    if @event.save
      flash[:success] = 'Event created successfully.'
      redirect_to calendar_path
    else
      flash[:danger] = 'Error occurred.'
      redirect_to calendar_path
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      flash[:success] = 'Updated event.'
      redirect_to calendar_path
    else
      flash[:danger] = 'Unable to update event.'
      redirect_to calendar_path
    end
  end

  def delete
    Event.find(params[:id]).destroy
    flash[:success] = 'Event removed.'
    redirect_to calendar_path
  end

  private

    def event_params
      params.require(:event).permit(:title, :description, :location, :startdate, :enddate, :notify, :notifydate)
    end
end
