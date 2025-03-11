class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.string :description
      t.date :date
      t.integer :category # Example: 'travel', 'meals', etc.
      t.references :user, foreign_key: true # User who submitted the expense

      t.timestamps
    end
  end
end