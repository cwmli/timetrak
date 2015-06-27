class EventsController < ApplicationController

  def new
  end

  def create
    event = current_account.teams.find_by(slug: params[:team_id]).events.build(event_params)
    event_dup = current_account.teams.find_by(name: params[:event][:team2]).events.build(event_params)
    if event.save && event_dup.save
      flash[:success] = 'Event created.'
      redirect_to calendar_path
    else
      flash[:error] = 'Error: Please make sure required fields are filled.'
      redirect_to calendar_path
    end
  end

  def edit
    @event = current_account.events.find(params[:id])
  end

  def update
    event = current_account.events.find(params[:id])
    event_affected = Event.where(team1: event.team1).where(team2: event.team2).where(startdate: event.startdate).where(starttime: event.starttime)

    if event.update_attributes(event_params)
      #get the new data and apply to related event
      team1 = event.team1
      team2 =  event.team2
      estime = event.starttime
      esdate = event.startdate
      eetime = event.endtime
      eedate = event.enddate

      event_affected.each do |t|
        t.update(team1: team1, team2: team2, starttime: estime, startdate: esdate, endtime: eetime, enddate: eedate)
      end

      flash[:success] = 'Updated event.'
      redirect_to calendar_path
    else
      flash[:error] = 'Unable to update event.'
      redirect_to calendar_path
    end
  end

  def delete
    #this delete method deletes the TWO events created for the each of the teams involved (team1 & team2)
    event = Event.find(params[:id])
    eteam1 = event.team1
    eteam2 = event.team2
    esdate = event.startdate
    estime = event.starttime

    #@event.destroy
    current_account.teams.each do |t|
      tev = t.events.where(team1: eteam1).where(team2: eteam2).where(startdate: esdate).where(starttime: estime)
      tev.each do |e|
        e.destroy
      end
    end
    flash[:success] = 'Event deleted.'
    redirect_to calendar_path
  end

  def destroy
    Event.find(params[:id]).destroy
  end

  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      if !current_account.nil?
        format.js
      else #not logged in, edit and delete privleges are removed
        format.js { render action: "view" }
      end
    end
  end

  def refresh
    old_venue_name = params[:old_venue_name]
    new_venue_name = params[:new_venue_name]

    old_team_name = params[:old_team_name]
    new_team_name = params[:new_team_name]

    season = Season.find_by(title: params[:season_name])

    if !old_venue_name.nil? #venue name given
      affected_events = []
      season.teams.each do |team| #collect all affected events
        teamevents = team.events.where(location: old_venue_name)
        affected_events.push(*teamevents)
      end

      if !affected_events.blank? #there are records with this venue name, update it
        affected_events.each do |event|
          event.update(location: new_venue_name)
        end
      end
    else #team name is given
      affected_events_team1 = []
      #collect all affected events with the team name
      season.teams.each do |team|
        teamevents = team.events.where(team1: old_team_name)
        affected_events_team1.push(*teamevents)
      end
      affected_events_team2 = []
      season.teams.each do |team|
        teamevents = team.events.where(team2: old_team_name)
        affected_events_team2.push(*teamevents)
      end

      if !affected_events_team1.blank? #there are records with this team name, update it
        affected_events_team1.each do |event|
          event.update(team1: new_team_name)
        end
      end

      if !affected_events_team2.blank?
        affected_events_team2.each do |event|
          event.update(team2: new_team_name)
        end
      end
    end
  end

  private
    def event_params
      params.require(:event).permit(:scheduled, :season_id, :team1, :team2, :description, :location, :startdate, :enddate, :starttime, :endtime, :notify, :notifydate)
    end
end
