class AccountsTable < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :username
      t.string :password_digest
      t.string :email

      t.timestamps null: false;
    end
  end
end
