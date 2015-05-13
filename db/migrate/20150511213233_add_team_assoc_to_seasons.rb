class AddTeamAssocToSeasons < ActiveRecord::Migration
  def change
    change_table :teams do |t|
      t.remove :seasons
      t.remove :account_id
      t.belongs_to :seasons, index: true
    end
  end
  remove_index :teams, :account_id
end
