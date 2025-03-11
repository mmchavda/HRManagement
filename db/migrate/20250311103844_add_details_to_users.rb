class AddDetailsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :username, :string
    add_column :users, :avatar, :string
    add_column :users, :bio, :text
    add_column :users, :phone_number, :string
    add_column :users, :dob, :date
    add_column :users, :is_active, :boolean, default: true
    add_column :users, :blood_group, :string
    add_column :users, :address, :text
    add_column :users, :gender, :string
  end
end
