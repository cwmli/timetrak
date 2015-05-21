class CalendarController < ApplicationController
  @@season = nil
  def show
    if !current_season.nil?
      @@season = current_season.id
    else
      redirect_to account_seasons_path(current_account)
    end

    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @teams_in_season = Team.where(season_id: @@season)
  end

  def all #show all events of all teams
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @teams_in_season = Team.where(season_id: @@season)
    @events_by_date = {}
    @events = []

    date_range = Date.today..Date.today.end_of_month
    if !@teams_in_season.empty? #fetch team events only if the season contains teams
      @teams_in_season.each do |team|
        @teamevents = team.events.group_by(&:startdate)
        @teamupcoming = team.events.where(startdate: date_range)
        @events_by_date = @events_by_date.merge(@teamevents){|key,oldval,newval| [*oldval].to_a + [*newval].to_a }
        @events.push(*@teamupcoming)
      end
      @events_by_date.each do |date, events_on_date_hash| #array of events on that date
        if events_on_date_hash.length > 1 #sort only if there are more than 2 events
          @events_by_date[date] = events_on_date_hash.sort_by { |h| h[:starttime] }
        end
      end

      @events = @events.sort_by { |h| h[:starttime]}

      respond_to do |format|
        format.js { render action: "calendar" }
      end
    end
  end

  def retrieve #fetch for one team
    @date = params[:date] ? Date.parse(params[:date]) : Date.today

    @team = Team.find_by(name: params[:team_name])
    @events_by_date = @team.events.group_by(&:startdate)

    @events_by_date.each do |date, events_on_date_hash| #array of events on that date
      if events_on_date_hash.length > 1 #sort only if there are more than 2 events
        @events_by_date[date] = events_on_date_hash.sort_by { |h| h[:starttime] }
      end
    end

    date_range = Date.today..Date.today.end_of_month
    @events = @team.events.where(startdate: date_range)
    @events = @events.sort_by { |h| h[:starttime]}

    respond_to do |format|
      format.js { render action: "calendar" }
    end
  end
end
