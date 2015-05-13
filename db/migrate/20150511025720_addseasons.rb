class Addseasons < ActiveRecord::Migration
  def change
    change_table :teams do |t|
      t.string :seasons, index: true
    end
  end
end
