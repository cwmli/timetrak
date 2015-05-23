class EditVenuesTable < ActiveRecord::Migration
  def change
    change_table :venues do |t|
      t.string :name
      t.string :location
      t.belongs_to :season, index: true
    end
  end
end
