class AddSlugToVenue < ActiveRecord::Migration
  def change
    change_table :venues do |t|
      t.string :slug
    end
  end
end
