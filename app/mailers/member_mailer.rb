class MemberMailer < ApplicationMailer

  def schedule_email(team)
    @team_name = team.name.to_s
    @season_name = Season.find(team.season_id).title.to_s
    @members = Member.where(team_id: team.id)
    @events = team.events
    @url = '/calendar?team_name='+Base64.encode(@team_name)

    @members.each do |m|
      mail(to: m.email, subject: @team_name+" Schedule for the "+@season_name+" Season")
    end
  end

end
