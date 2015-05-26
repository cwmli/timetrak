class TimeRestrictionsToVenues < ActiveRecord::Migration
  def change
    change_table :venues do |t|
      t.datetime :rs_start
      t.datetime :rs_end
    end
  end
end
