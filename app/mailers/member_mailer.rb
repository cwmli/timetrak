class MemberMailer < ApplicationMailer

  def schedule_email(team, season)
    team_name = team.name.to_s
    @season_name = Season.find(season).title.to_s
    members = Member.where(team_id: team.id)
    @events = team.events
    @url = 'timetrak.herokuapp.com/calendar/view?team_name='+Base64.encode64(team_name)+'&season='+Base64.encode64(season.to_s)

    members.each do |m|
      mail(to: m.email, subject: team_name+" Schedule for the "+@season_name+" Season") do |format|
        format.html
        format.text
      end
    end
  end

end
