class MembersController < ApplicationController

  def new
  end

  def
    @team = Team.find(params[:member][:team_id])
    @member = @team.members.build(member_params)

    respond_to do |format|
      @success = @member.save
      flash[:success] = 'Member added.'
      format.js
    end
  end

  private
  def member_params
    params.require(:member).permit(:name, :email, :team_id)
  end
end
