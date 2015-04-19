class CreateAccount < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :user
      t.string :pass
      t.string :email

      t.timestamps null: false
    end
  end
end
