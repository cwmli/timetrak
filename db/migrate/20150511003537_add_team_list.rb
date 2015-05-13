class AddTeamList < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.text :description
      t.integer :score

      t.string :slug

      t.belongs_to :account, index: true

      t.timestamps null: false
    end
  end
end
