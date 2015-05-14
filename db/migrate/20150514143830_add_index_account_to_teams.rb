class AddIndexAccountToTeams < ActiveRecord::Migration
  def change
    change_table :teams do |t|
      t.belongs_to :account
    end
  end
end
