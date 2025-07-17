class AddTlIdToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :tl_id, :integer
  end
end
