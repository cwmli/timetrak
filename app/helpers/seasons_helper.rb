module SeasonsHelper
  @@current_season = nil

  def current_season
    @@current_season #allow current season to be accessed as 'current_season' in controller views
  end
end
