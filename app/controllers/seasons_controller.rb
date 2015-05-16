class SeasonsController < ApplicationController
  @@current_season = nil

  def index
    @seasons = current_account.seasons
    @teams = current_account.teams
    @season = Season.new(account: current_account)
    @team = Team.new(account: current_account)
  end

  def new
  end

  def create
    @season = current_account.seasons.build(season_params)
    if @season.save
      flash[:success] = 'New season created.'
      @@current_season = nil #reset the variable on redirect
      redirect_to account_seasons_path(current_account)
    else
      flash[:error] = 'Error: Please make sure your season has a title.'
      @@current_season = nil
      redirect_to account_seasons_path(current_account)
    end
  end

  def edit
    current_season
  end

  def update
    if current_season.update_attributes(season_params)
      flash[:success] = 'Updated season.'
      @@current_season = nil
      redirect_to account_seasons_path(current_account)
    else
      flash[:error] = 'Unable to update season.'
      @@current_season = nil
      redirect_to account_seasons_path(current_account)
    end
  end

  def destroy
    Season.find(params[:id]).destroy
    flash[:success] = 'Season deleted.'
    redirect_to account_seasons_path(current_account)
    @@current_season = nil #reset the variable
  end

  def details
    @team_names = Array.new
    @season_nfo = Season.find_by(title: params[:season_name])
    @@current_season = @season_nfo #update the selected season

    @teamlist = Team.where(season_id: @season_nfo.id)
    if !@teamlist.nil? #not empty
      @teamlist.each do |team|
        @team_names.push(team.name)
      end
    end
    render json: @team_names
  end

  private
    def season_params
      params.require(:season).permit(:title, :teams)
    end
end
