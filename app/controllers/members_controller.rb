class MembersController < ApplicationController

  def new
  end

  def create
    @team = Team.find(params[:member][:team_id])
    @team_name = @team.name
    @member = @team.members.build(member_params)

    respond_to do |format|
      @success = @member.save
      format.js
    end
  end

  def destroy
    @member = Member.find(params[:id])
    @team = Team.find_by(id: @member.team_id).name
    @success = @member.destroy

    respond_to do |format|
      format.js
    end
  end

  private
  def member_params
    params.require(:member).permit(:name, :email, :team_id)
  end
end
