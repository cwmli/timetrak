class RemoveIndexTeamsFromSeasons < ActiveRecord::Migration
  def change
    remove_index :seasons, :teams
  end
end
