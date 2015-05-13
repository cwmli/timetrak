class SplitDatetimeInEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.remove :startdate,:enddate
      t.date :startdate, :enddate
      t.time :starttime, :endtime
    end
  end
end
