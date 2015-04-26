class Events < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :description #nullable
      t.text :location #nullable

      t.datetime :startdate #convert with strftime to parse date info
      t.datetime :enddate

      t.boolean :notify #notify the user of the upcoming event
      t.datetime :notifydate #when do you want to be notified?
    end
  end
end
