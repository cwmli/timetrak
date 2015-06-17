class TeamsController < ApplicationController
  def index
    @teams = current_account.teams
  end

  def new
  end

  def create
    @team = current_account.teams.build(team_params)

    respond_to do |format|
      if @team.save
        @success = true
      end
      format.js
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
        @success = true
      end
      format.js
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team_name = @team.name
    @season = Season.find_by(id: @team.season_id)
    if !@season.nil?
      @season = @season.title
    end

    #delete other affected events
    Event.where(team1: @team.name).destroy_all
    Event.where(team2: @team.name).destroy_all

    @team.destroy

    respond_to do |format|
      format.js
    end
  end

  def details
    @account = current_account
    @team = Team.find_by(name: params[:team_name])
    @members = Member.where(team_id: @team.id)
    @name = @team.name
    @slug = @team.slug
    @desc = @team.description
    if @desc.nil?
      @desc = "No description available"
    end

    @season = @team.seasons
    if @season.blank?
      @season = 0
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
