class VenuesController < ApplicationController

  def new
  end

  def create
    @venue = current_season.venues.build(venue_params)

    respond_to do |format|
      if @venue.save
        format.js
      else
        format.html { redirect_to account_seasons_path(current_account), flash: { error: 'Venue missing a location.'}}
      end
    end
  end

  private
  def venue_params
    params.require(:venue).permit(:name, :location)
  end
end
