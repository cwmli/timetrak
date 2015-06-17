class Addbelongstoseasonteams < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.belongs_to :season, index: true
    end
  end
end
