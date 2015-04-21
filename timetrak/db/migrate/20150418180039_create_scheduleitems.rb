class CreateScheduleItems < ActiveRecord::Migration
  def change
    create_table :schedule_items do |t|
      t.string :title
      t.text :desc
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps null: false
    end
  end
end
