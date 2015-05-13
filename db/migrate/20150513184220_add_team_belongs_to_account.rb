class AddTeamBelongsToAccount < ActiveRecord::Migration
  def change
    change_table :teams do |t|
      t.belongs_to :account, index: true
      t.remove :account_id_id
    end
      remove_index :teams, :account_id
  end
end
