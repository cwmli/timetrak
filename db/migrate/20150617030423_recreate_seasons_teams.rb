class RecreateSeasonsTeams < ActiveRecord::Migration
  def change
    drop_table :seasons_teams
    change_table :teams do |t|
      t.remove :season_id
    end

    create_table :seasons_teams, id: false do |t|
      t.belongs_to :season, index: true
      t.belongs_to :team, index: true
    end
  end
end
