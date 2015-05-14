class ReAssocTeamsToAccount < ActiveRecord::Migration
  def change
    change_table :teams do |t|
      t.remove :account_id
      t.belongs_to :account, index: true
    end
  end
end
