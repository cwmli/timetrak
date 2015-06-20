class MembersController < ApplicationController

  def new
  end

  def create
    team = Team.find(params[:member][:team_id])
    @team_name = team.name
    member = team.members.build(member_params)

    respond_to do |format|
      if member.save
        format.js
      else
        @message = 'Error: Missing Email and/or Name fields.'
        format.js { render action: 'layouts/error'}
      end
    end
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    member = Member.find(params[:id])
    @team_name = Team.find(member.team_id).name

    respond_to do |format|
      if member.update_attributes(member_params)
        format.js
      else
        @message = 'Error: Unable to update member information.'
        format.js { render action: 'layouts/error'}
      end
    end
  end

  def destroy
    member = Member.find(params[:id])
    @team = Team.find_by(id: member.team_id).name

    respond_to do |format|
      if member.destroy
        format.js
      else
        @message = 'Error: Unable to delete member from team.'
        format.js { render action: 'layouts/error'}
      end
    end
  end

  private
  def member_params
    params.require(:member).permit(:name, :email, :team_id)
  end
end
