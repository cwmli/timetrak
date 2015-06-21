class VenuesController < ApplicationController

  def new
  end

  def create
    venue = current_season.venues.build(venue_params)

    respond_to do |format|
      if venue.save
        format.js
      else
        @message = 'Error: Venue is missing a name and/or location.'
        format.js { render action: 'layouts/error'}
      end
    end
  end

  def edit
    @venue = current_season.venues.find_by(name: params[:id])
  end

  def update
    @venue = current_season.venues.find(params[:id])
    @old_venue_name = @venue.name

    respond_to do |format|
      if @venue.update_attributes(venue_params)
        format.js
      else
        @message = 'Error: Unable to update venue.'
        format.js { render action: 'layouts/error'}
      end
    end
  end

  def destroy
    venue = Venue.find(params[:id])
    @venue_name = venue.name
    @season = Season.find_by(id: venue.season_id)
    if !@season.nil?
      @season = @season.title
    end

    respond_to do |format|
      if Event.where(location: venue.name).destroy_all && venue.destroy
        format.js
      else
        @message = 'Error: Unable to delete venue.'
        format.js { render action: 'layouts/error'}
      end
    end
  end

  def details
    @account = current_account
    @venue = Venue.find_by(name: params[:venue_name])
    @season = Season.find_by(id: @venue.season_id)

    respond_to do |format|
      if !@venue.nil?
        format.js
      else
        @message = 'Error: Could not retrieve venue information.'
        format.js { render action: 'layouts/error'}
      end
    end
  end

  private
  def venue_params
    params.require(:venue).permit(:name, :location)
  end
end
