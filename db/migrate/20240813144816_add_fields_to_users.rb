class AddFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :phone_number, :string
    add_column :users, :phone_number_confirmation_token, :string
    add_column :users, :phone_number_confirmed_at, :datetime
    add_column :users, :phone_number_confirmation_created_at, :datetime
    add_column :users, :unconfirmed_phone_number, :string
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

    execute <<-SQL
      ALTER TABLE users
      ADD COLUMN full_name VARCHAR GENERATED ALWAYS AS (first_name || ' ' || last_name) STORED;
    SQL

    add_index :users, :confirmation_token,   unique: true
    add_index :users, :phone_number_confirmation_token, unique: true, where: "phone_number_confirmation_token IS NOT NULL"
    add_index :users, :phone_number, unique: true
  end
end
