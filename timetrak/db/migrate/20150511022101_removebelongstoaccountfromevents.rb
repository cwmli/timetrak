class Removebelongstoaccountfromevents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.remove :account_id
      t.belongs_to :team, index: true
    end
  end
  remove_index :events, :account_id
end
