class AddSlugToEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.string :slug
    end
    add_index :events, :slug, unique: true
  end
end
