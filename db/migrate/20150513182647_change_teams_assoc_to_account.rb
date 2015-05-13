class ChangeTeamsAssocToAccount < ActiveRecord::Migration
  def change
    remove_index :teams, :seasons_id
  end
end
