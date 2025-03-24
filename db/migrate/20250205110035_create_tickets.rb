class CreateTickets < ActiveRecord::Migration[8.0]
  def change
    create_table :tickets do |t|
      t.string :title
      t.text :description
      t.integer :status 
      t.integer :priority
      t.references :user, foreign_key: true, type: :bigint # Ensure user_id is bigint
      t.references :assigned_user, foreign_key: { to_table: :users }, type: :bigint # Ensure assigned_user_id is bigint

      t.timestamps
    end
  end
end