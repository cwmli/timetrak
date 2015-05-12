class SeasonsController < ApplicationController
  def index
    @seasons = current_account.seasons
  end

  def new
  end

  def create
    @season = current_account.seasons.build(season_params)
    if @season.save
      flash[:success] = 'New season created.'
      redirect_to account_teams_path(current_account)
    else
      flash[:error] = 'Error: Please make sure your season has a title.'
      redirect_to account_teams_path(current_account)
    end
  end

  def details
    @season_nfo = {success}

    respond_to do |format|
      format.html
      format.json { render json: @season_nfo }
    end
  end
end
