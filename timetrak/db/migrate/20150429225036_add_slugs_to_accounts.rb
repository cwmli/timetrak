class AddSlugsToAccounts < ActiveRecord::Migration
  def change
    change_table :accounts do |t|
      t.string :slug
    end
    add_index :accounts, :slug, unique: true
  end
end
