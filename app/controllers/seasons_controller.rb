class SeasonsController < ApplicationController
  before_filter :current_season, only: :index

  def index
    current_season
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

  def details
    @team_names = Array.new
    @season_nfo = Season.find_by(title: params[:season_name])
    current_season = @season_nfo
    @season_nfo.teams.each do |s|
      @team_names.push = s.name
    end
    render json: @team_names
  end

  def current_season
    @current_season = current_account.seasons.first
  end

  private
    def season_params
      params.require(:season).permit(:title, :teams)
    end
end
