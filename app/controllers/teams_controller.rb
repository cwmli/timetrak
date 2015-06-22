class TeamsController < ApplicationController
  def create
    @team = current_account.teams.build(team_params)

    respond_to do |format|
      if @team.save
        format.js
      else
        @message = 'Error: Please make sure the team has a name.'
        format.js { render action: 'layouts/error'}
      end
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
        @message = 'Error: Unable to update team information.'
        format.js { render action: 'layouts/error'}
      end
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team_name = @team.name
    @season = current_season.title

    respond_to do |format|
      if Event.where(team1: @team.name).destroy_all && Event.where(team2: @team.name).destroy_all && @team.destroy
        format.js
      else
        @message = 'Error: Unable to delete team.'
        format.js { render action: 'layouts/error'}
      end
    end
  end

  def link_to_season
    @team = Team.find(params[:id])
    @season = current_season.id

    respond_to do |format|
      if @team.seasons << current_season #add a join between selected season and the team
        if !current_season.generated.nil? #a season with generated schedule exists, insert team accordingly
          format.js { render action: 'insert'}
        else
          format.js
        end
      else
        @message = 'Error: Could not add team to season.'
        format.js { render action: 'layouts/error'}
      end
    end
  end

  def unlink_from_season
    @team = Team.find_by(id: params[:id])
    if @team.nil?
      @team = Team.find_by(name: params[:id])
    end

    respond_to do |format|
      if @team.seasons.delete(current_season) #remove join between selected season and the team
        format.js
      else
        @message = 'Error: Could not remove team from season.'
        format.js { render action: 'layouts/error'}
      end
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

    respond_to do |format|
      if !@team.nil?
        format.js
      else
        @message = 'Error: Could not retrieve team information with name: '+params[:team_name]+'.'
        format.js { render action: 'layouts/error'}
      end
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :description, :score, :season_id)
  end
end
