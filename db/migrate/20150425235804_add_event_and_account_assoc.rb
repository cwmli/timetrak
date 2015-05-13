class AddEventAndAccountAssoc < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.belongs_to :account, index: true
    end
  end
end
