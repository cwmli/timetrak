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

  def generate
    @teams_in_season = Team.where(season_id: @@season).in_groups(2) #split into two equal arrays
    @venues = current_season.venues
    @start = Date.parse(params[:startdate])
    @stime = params[:starttime]
    @etime = params[:endtime]
    @games_per_week = params[:limit]
    @selected_days = params[:weekdays].map(&:to_i)
    @permitted_weekdays = (@start..@start+1.year).select { |k| @selected_days.include?(k.wday)}
    @success = nil
    @total_teams = @teams_in_season[0].count.to_i+@teams_in_season[1].count.to_i

    @events_created = 0
    @events_required = (@total_teams-1)*2

    for r in 0..(@total_teams/@games_per_week.to_i)-1 #number of weeks needed
      for g in 0..@games_per_week.to_i-1 #number of days available
        @venue_index = 0
        for t in 0..(@total_teams/2)-1#teams in one group
          if @teams_in_season[0][t].nil? || @teams_in_season[1][t].nil?
            break #the team gets a 'bye' since they are not versing anyone
          else
            if @venues[@venue_index].blank?
              break(3)
            else
              @event1 = @teams_in_season[0][t].events.build(team1: @teams_in_season[0][t].name, team2: @teams_in_season[1][t].name, startdate: @permitted_weekdays[g+r*(@games_per_week.to_i)], enddate: @permitted_weekdays[g+r*(@games_per_week.to_i)], starttime: @stime, endtime: @etime, location: @venues[@venue_index].name)
              @event2 = @teams_in_season[1][t].events.build(team1: @teams_in_season[0][t].name, team2: @teams_in_season[1][t].name, startdate: @permitted_weekdays[g+r*(@games_per_week.to_i)], enddate: @permitted_weekdays[g+r*(@games_per_week.to_i)], starttime: @stime, endtime: @etime, location: @venues[@venue_index].name) #add the event for the opposing team too
              @venue_index += 1
              @events_created += 1
              if @events_created > @events_required
                break(3)
              else
                @event1.save
                @event2.save
              end
            end
          end
        end
        #rearrange the arrays after all events are saved for this group organization
        @teams_in_season[1].unshift(@teams_in_season[0].pop) #push the last team of group1 to the beginning of group2
        @teams_in_season[0].insert(1, @teams_in_season[1].pop) #push the last team of group2 to the second index on group1
      end
      @success = 1
    end

    respond_to do |format|
      format.js #flash message contains success
    end
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
