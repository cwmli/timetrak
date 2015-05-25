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
      flash[:error] = "Error: Please make sure your team has a name."
      redirect_to account_seasons_path(current_account)
    end
  end

  def edit
    @team = current_account.teams.find_by(name: params[:id])
  end

  def update
    @team = current_account.teams.find(params[:id])
    @old_team_name = @team.name

    respond_to do |format|
      if @team.update_attributes(team_params)
        format.js
      else
        format.html { redirect_to account_seasons_path(current_account), flash: { error: 'Unable to update team.'}}
      end
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team_name = @team.name
    @season = Season.find_by(id: @team.season_id)
    if !@season.nil?
      @season = @season.title
    end

    @team.destroy

    respond_to do |format|
      format.js
    end
  end

  def details
    @account = current_account
    @team = Team.find_by(name: params[:team_name])
    @name = @team.name
    @slug = @team.slug
    @desc = @team.description
    if @desc.empty?
      @desc = "No description available"
    end

    @season = Season.find_by(id: @team.season_id)
    if @season.nil?
      @season = "Not in any season."
    else
      @season = @season.title
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :description, :score, :season_id)
  end
end
