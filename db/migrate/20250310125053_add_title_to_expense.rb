class AddTitleToExpense < ActiveRecord::Migration[8.0]
  def change
    add_column :expenses, :title, :string
  end
end
