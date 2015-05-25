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

  def refresh
    @old_venue_name = params[:old_venue_name]
    @new_venue_name = params[:new_venue_name]

    @old_team_name = params[:old_team_name]
    @new_team_name = params[:new_team_name]

    @season = Season.find_by(title: params[:season_name])

    if !@old_venue_name.nil? #venue needs to be changed
      @affected_events = []
      @season.teams.each do |team|
        @teamevents = team.events.where(location: @old_venue_name)
        @affected_events.push(*@teamevents)
      end

      if !@affected_events.blank?
        @affected_events.each do |event|
          event.update(location: @new_venue_name)
        end
      end
    else #change teams
      @affected_events_team1 = []
      @season.teams.each do |team|
        @teamevents = team.events.where(team1: @old_team_name)
        @affected_events_team1.push(*@teamevents)
      end
      @affected_events_team2 = []
      @season.teams.each do |team|
        @teamevents = team.events.where(team2: @old_team_name)
        @affected_events_team2.push(*@teamevents)
      end

      if !@affected_events_team1.blank?
        @affected_events_team1.each do |event|
          event.update(team1: @new_team_name)
        end
      end

      if !@affected_events_team2.blank?
        @affected_events_team2.each do |event|
          event.update(team2: @new_team_name)
        end
      end
    end
  end

  private
    def event_params
      params.require(:event).permit(:title, :description, :location, :startdate, :enddate, :starttime, :endtime, :notify, :notifydate)
    end
end
