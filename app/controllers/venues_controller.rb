class VenuesController < ApplicationController

  def new
  end

  def create
    @venue = current_season.venues.build(venue_params)

    respond_to do |format|
      if @venue.save
        format.js
      else
        format.js
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
        format.js
      end
    end
  end

  def destroy
    @venue = Venue.find(params[:id])
    @venue_name = @venue.name
    @season = Season.find_by(id: @venue.season_id)
    if !@season.nil?
      @season = @season.title
    end

    #delete affected events
    Event.where(location: @venue.name).destroy_all
    @venue.destroy

    respond_to do |format|
      format.js
    end
  end

  def details
    @account = current_account
    @venue = Venue.find_by(name: params[:venue_name])
    @slug = @venue.slug
    @season = Season.find_by(id: @venue.season_id)
    if !@season.nil?
      @seasonslug = @season.slug
    end

    respond_to do |format|
      format.js
    end
  end

  private
  def venue_params
    params.require(:venue).permit(:name, :location)
  end
end
