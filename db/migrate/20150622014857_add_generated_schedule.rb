class AddGeneratedSchedule < ActiveRecord::Migration
  def change
    change_table :seasons do |t|
      t.integer :generated
    end

    change_table :events do |t|
      t.integer :scheduled
    end
  end
end
