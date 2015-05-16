class SeasonsController < ApplicationController
  before_filter :current_season

  def index
    @seasons = current_account.seasons
    @teams = current_account.teams
    @team = Team.new(account: current_account)
  end

  def new
  end

  def create
    @season = current_account.seasons.build(season_params)
    if @season.save
      flash[:success] = 'New season created.'
      redirect_to account_seasons_path(current_account)
    else
      flash[:error] = 'Error: Please make sure your season has a title.'
      redirect_to account_seasons_path(current_account)
    end
  end

  def edit
    current_season
  end

  def update
    if current_season.update_attributes(season_params)
      flash[:success] = 'Updated season.'
      redirect_to account_seasons_path(current_account)
    else
      flash[:error] = 'Unable to update season.'
      redirect_to account_seasons_path(current_account)
    end
  end

  def destroy
    Season.find(params[:id]).destroy
    flash[:success] = 'Season deleted.'
    redirect_to account_seasons_path(current_account)
  end

  def details
    @team_names = Array.new
    @current_season = @season_nfo = Season.find_by(title: params[:season_name])
    if !@season_nfo.teams.nil? #not empty
      @season_nfo.teams.each do |team|
        @team_names.push(team.name)
      end
    end
    render json: @team_names
  end

  def current_season
    if current_account.seasons.empty? #is empty
      @current_season =  Season.new(account: current_account)
    else
      @current_season = current_account.seasons.first
    end
  end

  private
    def season_params
      params.require(:season).permit(:title, :teams)
    end
end
