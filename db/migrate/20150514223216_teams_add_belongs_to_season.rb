class TeamsAddBelongsToSeason < ActiveRecord::Migration
  def change
    change_table :seasons do |t|
      t.remove :teams
    end
    change_table :teams do |t|
      t.belongs_to :season, index: true
    end
  end
end
