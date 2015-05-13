class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.string :title
      t.string :teams, index: true
      t.string :slug, index: true, unique: true
      t.belongs_to :account, index: true

      t.timestamps null: false
    end
  end
end
