class ChangeEventsTable < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.remove :title
      t.string :team1
      t.string :team2
    end
  end
end
