class AddSlugToMembers < ActiveRecord::Migration
  def change
    change_table :members do |t|
      t.string :slug
    end
  end
end
