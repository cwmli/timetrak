class EventsController < ApplicationController

  def new
  end

  def create
    @event = Event.new(params.require(:title, :startdate, :enddate).permit(:event))
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      render calendar_path
    else
      render calendar_path
      flash.now[:danger] = 'Unable to update event.'
    end
  end

  def delete
    Event.find(params[:id]).destroy
    render calendar_path
    flash.now[:success] = 'Event removed.'
  end
end
