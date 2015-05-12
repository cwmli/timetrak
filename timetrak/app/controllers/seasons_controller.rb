class SeasonsController < ApplicationController
  def index
    @seasons = current_account.seasons
    @season = Season.new(account: current_account)
    #team object
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

  def details
    @season_nfo = Season.find_by(title: params[:season_name])
    render json: @season_nfo.teams
  end

  private
    def season_params
      params.require(:season).permit(:title, :teams)
    end
end
