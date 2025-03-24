class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.string :description
      t.date :date
      t.integer :category
      t.references :user, null: false, foreign_key: true, type: :bigint # Ensure user_id is bigint
      t.timestamps
    end
  end
end