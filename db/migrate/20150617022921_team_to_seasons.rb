class TeamToSeasons < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.belongs_to :season, index: true
    end

    change_table :teams do |t|
      t.remove :season_id
    end

    create_table :teams_seasons, id: false do |t|
      t.integer :team_id
      t.integer :season_id
    end
  end
end
