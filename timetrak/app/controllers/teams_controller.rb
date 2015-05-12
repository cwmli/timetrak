class TeamsController < ApplicationController
  def index
    @teams = current_account.season.teams
  end

  def new
  end

  def create
    @team = current_account.teams.build(team_params)
    if @team.save
      flash[:success] = "Team created."
      redirect_to account_teams_path(current_account)
    else
      flash[:error] = "Error: Please make sure you team has a name."
      redirect_to account_teams_path(current_account)
    end
  end

  def edit
    @team = current_account.teams.find(params[:id])
  end

  def update
    @team = current_account.teams.find(params[:id])
    if @event.update_attributes(event_params)
      flash[:success] = 'Updated team.'
      redirect_to account_teams_path(current_account)
    else
      flash[:error] = 'Unable to update team.'
      redirect_to account_teams_path(current_account)
    end
  end

  def destroy
    Team.find(params[:id]).destroy
    flash[:success] = 'Team deleted.'
    redirect_to account_teams_path(current_account)
  end

  private

  def team_params
    params.require(:team).permit(:name, :description, :score)
  end
end
