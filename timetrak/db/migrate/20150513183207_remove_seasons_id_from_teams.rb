class RemoveSeasonsIdFromTeams < ActiveRecord::Migration
  def change
    change_table :teams do |t|
      t.remove :seasons_id
    end
  end
end
