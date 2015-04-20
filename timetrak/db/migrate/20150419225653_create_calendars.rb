class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.string :name
      t.string :owners, :array => true, :length => 25

      t.timestamps null: false
    end
  end
end
