class CalendarController < ApplicationController
  @@season = nil

  def show
    if !current_season.nil?
      @@season = current_season.id
      @teams_in_season = current_season.teams
    else
      redirect_to account_seasons_path(current_account)
    end

    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end

  def view
    @param1 = params[:team_name]
    @param2 = params[:season]
    season_id = Base64.urlsafe_decode64(params[:season])
    team = Team.find_by(name: Base64.urlsafe_decode64(params[:team_name]))
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @events_by_date = team.events.where(season_id: season_id).group_by(&:startdate)

    @events_by_date.each do |date, events_on_date_hash| #array of events on that date
      if events_on_date_hash.length > 1 #sort only if there are more than 2 events
        @events_by_date[date] = events_on_date_hash.sort_by { |h| h[:starttime] }
      end
    end

    date_range = Date.today..Date.today+2.weeks
    @events = team.events.where(season_id: season_id).where(startdate: date_range)
    @events = @events.sort_by { |h| h[:starttime]}
  end

  def mail
    current_season.teams.each do |team|
      MemberMailer.schedule_email(team, @@season).deliver
    end

    respond_to do |format|
      format.js
    end
  end

  def insert
    team = Team.find(params[:id])
    season = Season.find(params[:season_id])
    venues = season.venues
    oppositions = season.teams.where("name != ?", team.name)
    total_teams = oppositions.count
    events = season.events.where(scheduled: 1)
    #get event starttimes and end timeslots
    stime = events[0].starttime
    etime = events[0].endtime
    #ignore single events and group by week number
    wn_events = events.group_by{|u| u.startdate.strftime('%W')}
    #find the max events per week and the permitted days
    event_counts = []
    startdates = []
    selected_days = []
    wn_events.each do |week_num, e|
      event_counts.push(e.count/total_teams)
      e.each do |s|
        startdates.push(s.startdate)
        if !selected_days.include?(s.startdate.wday)
          selected_days.push(s.startdate.wday)
        end
      end
    end
    weeks_in_season = (wn_events.keys[wn_events.count-1].to_i - wn_events.keys[0].to_i)+1
    start = startdates.min
    permitted_days = (start..start+1.year).select { |k| selected_days.include?(k.wday)}
    games_per_week = event_counts.max
    events_q = 1
    events_req = (total_teams)*2
    #this gives how many weeks are required (provided no pre-existing events)
    weeks_required = ((events_req/2)/games_per_week.to_f).ceil

    for w in 0..(weeks_in_season+weeks_required)-1 #check the first weeks
      for g in 0..games_per_week.to_i-1 #check the permitted days
        for t in 0..total_teams-1 #check through teams
          catch (:success) do #refresh all the match events when a new one has been created
            match_event = oppositions[t].events.where(season_id: season.id).where(scheduled: 1).where(startdate: permitted_days[g+w*(games_per_week.to_i)])
            if match_event.blank?
              for v in 0..venues.count-1 #check each venue
                vfiltered_match_event = Event.where(season_id: season.id).where(scheduled: 1).where(startdate: permitted_days[g+w*(games_per_week.to_i)]).where(location: venues[v].name)
                if vfiltered_match_event.blank? && events_q <= events_req #this team is free at this time with location
                  oppositions[t].events.build(scheduled: '1', season_id: params[:season_id], team1: oppositions[t].name, team2: team.name, startdate: permitted_days[g+w*(games_per_week.to_i)], enddate: permitted_days[g+w*(games_per_week.to_i)], starttime: stime, endtime: etime, location: venues[v].name).save
                  team.events.build(scheduled: '1', season_id: params[:season_id], team1: oppositions[t].name, team2: team.name, startdate: permitted_days[g+w*(games_per_week.to_i)], enddate: permitted_days[g+w*(games_per_week.to_i)], starttime: stime, endtime: etime, location: venues[v].name).save
                  events_q += 1
                  throw (:success)#update the match_events
                else
                  next
                end
              end
            else
              next
            end
          end
        end
      end
    end

    respond_to do |format|
      format.js
    end
  end

  def generate
    teams = Season.find(@@season).teams.in_groups(2) #split into two equal arrays
    venues = Season.find(@@season).venues
    start = Date.parse(params[:startdate])
    stime = params[:starttime]
    etime = params[:endtime]
    games_per_week = params[:limit]
    selected_days = params[:weekdays].map(&:to_i)
    permitted_days = (start..start+1.year).select { |k| selected_days.include?(k.wday)}
    #convert nil values to 'nil' strings for shifting later
    @teams_in_season = []
    @teams_in_season.push(teams[0].map { |e| !e ? 'nil' : e })
    @teams_in_season.push(teams[1].map { |e| !e ? 'nil' : e })
    @success = nil
    @message = nil
    total_teams = @teams_in_season[0].count.to_i+@teams_in_season[1].count.to_i
    event_build_list = []
    events_q = 1
    events_req = ((total_teams/2)*(total_teams-1))*2 # vs twice
    p events_req
    catch (:error) do
      for r in 0..(((events_req/2)/games_per_week.to_f).ceil)-1 #number of weeks needed
        for g in 0..games_per_week.to_i-1 #number of days available
          venue_index = 0
          for t in 0..((total_teams/2)-1)#iterate through teams in one group to save the matchups
            #team automatically gets a 'bye', they are not versing anyone if team1 or 2 is nil
            if @teams_in_season[0][t] == 'nil' || @teams_in_season[1][t] == 'nil'
              events_q += 1
              next
            end
            if venues[venue_index].nil?
              @message = 'Not enough venues.'
              throw (:error)
            elsif events_q <= events_req #queue new events for building later
              event_build_list.push(@teams_in_season[0][t].events.build(scheduled: '1', season_id: @@season,team1: @teams_in_season[0][t].name, team2: @teams_in_season[1][t].name, startdate: permitted_days[g+r*(games_per_week.to_i)], enddate: permitted_days[g+r*(games_per_week.to_i)], starttime: stime, endtime: etime, location: venues[venue_index].name))
              event_build_list.push(@teams_in_season[1][t].events.build(scheduled: '1', season_id: @@season,team1: @teams_in_season[0][t].name, team2: @teams_in_season[1][t].name, startdate: permitted_days[g+r*(games_per_week.to_i)], enddate: permitted_days[g+r*(games_per_week.to_i)], starttime: stime, endtime: etime, location: venues[venue_index].name)) #add the event for the opposing team too
              venue_index += 1
              events_q += 1
            else
              break #sufficient events queued
            end
          end
          #rearrange the arrays after all events are saved for this group organization
          if total_teams > 2
            @teams_in_season[1].push(@teams_in_season[0].pop) #push the last team of group1 to the end of group2
            @teams_in_season[0].insert(1, @teams_in_season[1].shift) #push the last team of group2 to the second index on group1
          end
        end
      end
      @success = 1
      Season.find(@@season).update(generated: '1')#Schedule has been generated in this season
      event_build_list.each do |e|
        e.save
      end
    end

    respond_to do |format|
      format.js #flash message contains success
    end
  end

  def all #show all events of all teams
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    teams_in_season = Season.find(@@season).teams
    @events_by_date = {}
    @events = []

    date_range = Date.today..Date.today+2.weeks
    if !teams_in_season.empty? #fetch team events only if the season contains teams
      teams_in_season.each do |team|
        teamevents = team.events.where(season_id: @@season).group_by(&:startdate)
        teamupcoming = team.events.where(season_id: @@season).where(startdate: date_range)
        @events_by_date = @events_by_date.merge(teamevents){|key,oldval,newval| [*oldval].to_a + [*newval].to_a }
        @events.push(*teamupcoming)
      end
      @events_by_date.each do |date, events_on_date_hash| #array of events on that date
        if events_on_date_hash.length > 2 #sort only if there are more than 2 events
          @events_by_date[date] = events_on_date_hash.sort_by { |h| h[:starttime] }
        end
      end
      @events = @events.sort_by { |h| h[:starttime]}

      #remove duplicates
      @events = @events.uniq {|event| [event[:team1], event[:team2], event[:startdate]]} #in sidebar
      @events_by_date.each do |date, collection| #in calendar
        @events_by_date[date] = collection.uniq {|event| [event[:team1], event[:team2], event[:startdate]]}
      end

      respond_to do |format|
        format.js { render action: "calendar" }
      end
    end
  end

  def retrieve #fetch for one team
    @date = params[:date] ? Date.parse(params[:date]) : Date.today

    @team = Team.find_by(name: params[:team_name])
    @@current_team = @team
    @events_by_date = @team.events.where(season_id: @@season).group_by(&:startdate)

    @events_by_date.each do |date, events_on_date_hash| #array of events on that date
      if events_on_date_hash.length > 2 #sort only if there are more than 2 events
        @events_by_date[date] = events_on_date_hash.sort_by { |h| h[:starttime] }
      end
    end

    date_range = Date.today..Date.today+2.weeks
    @events = @team.events.where(season_id: @@season).where(startdate: date_range)
    @events = @events.sort_by { |h| h[:starttime]}

    respond_to do |format|
      format.js { render action: "calendar" }
    end
  end
end
