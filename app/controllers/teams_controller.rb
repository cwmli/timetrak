class TeamsController < ApplicationController
  def index
    @teams = current_account.teams
  end

  def new
  end

  def create
    @team = current_account.teams.build(team_params)
    if @team.save
      flash[:success] = "Team created."
      redirect_to account_seasons_path(current_account)
    else
      flash[:error] = "Error: Please make sure you team has a name."
      redirect_to account_seasons_path(current_account)
    end
  end

  def edit
    @team = current_account.teams.find(params[:id])
  end

  def update
    @team = current_account.teams.find_by(name: params[:team_name])
    if @team.update_attributes(team_params)
      flash.now[:success] = 'Updated team.'
      render account_seasons_path(current_account)
    else
      flash.now[:error] = 'Unable to update team.'
      render account_seasons_path(current_account)
    end
  end

  def destroy
    Team.find(params[:id]).destroy
    flash[:success] = 'Team deleted.'
    redirect_to account_seasons_path(current_account)
  end

  private

  def team_params
    params.require(:team).permit(:name, :description, :score)
  end
end
