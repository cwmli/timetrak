class SeasonsController < ApplicationController

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
      flash[:error] = 'Error: Unable to update season.'
      @@current_season = nil
      redirect_to account_seasons_path(current_account)
    end
  end

  def destroy
    if Season.find(params[:id]).destroy && Event.where(season_id: params[:id]).destroy_all
      flash[:success] = 'Season deleted.'
      @@current_season = nil #reset the variable
      redirect_to account_seasons_path(current_account)
    else
      flash[:error] = 'Error: Unable to delete season.'
      redirect_to account_seasons_path(current_account)
    end
  end

  def details
    @team_names = Array.new
    @season_nfo = Season.find_by(title: params[:season_name])
    @@current_season = @season_nfo #update the selected season

    @account = current_account

    teamlist = @season_nfo.teams
    if !teamlist.nil? #not empty
      teamlist.each do |team| #populate the team names
        @team_names.push(team.name)
      end
    end

    respond_to do |format|
      if !@season_nfo.nil? #season could be found
        format.js
      else
        @message = 'Error: Could not find season info with name: '+params[:season_name]+'.'
        format.js { render action: 'layouts/error'}
      end
    end
  end

  def upload #read and submit uploaded data using Roo
    excel_file = Roo::Spreadsheet.open(params[:datafile])
    season = Season.find_by(title: params[:season_title])
    @failcount = 0
    sheets = excel_file.sheets

    sheets.each do |sheet_name|
      current_sheet = excel_file.sheet(sheet_name)
      for row in current_sheet.first_row+1..current_sheet.last_row
        data = []
        rowdata = current_sheet.row(row)
        for index in 0..current_sheet.last_column #assumption that rowdata has the same length as column_names
          data.push(rowdata[index])
        end
        #check where to put this data
        if sheet_name == "Teams"
          team = current_account.teams.build(name: data[0])
          if !team.save
            @failcount += 1
          end
        else #is a venue upload
          #parse date restrictions:
          rsstart = DateTime.parse(data[2])
          rsend = DateTime.parse(data[3])
          venue = season.venues.build(name: data[0], location: data[1])
          if !venue.save
            @failcount += 1
          end
        end
      end
    end

    respond_to do |format|
      if @failcount == 0
        format.html { redirect_to :back, flash: { alert: "Uploaded schedule/team data saved successfully." } }
      else
        format.html { redirect_to :back, flash: { alert: @failcount+" records could not be saved." } }
      end
    end
  end

  private
    def season_params
      params.require(:season).permit(:title, :generated)
    end
end
