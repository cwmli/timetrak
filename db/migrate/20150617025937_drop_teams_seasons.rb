class DropTeamsSeasons < ActiveRecord::Migration
  def change
    drop_table :teams_seasons
    create_table :seasons_teams do |t|
      t.integer :season_id
      t.integer :team_id
    end
  end
end
