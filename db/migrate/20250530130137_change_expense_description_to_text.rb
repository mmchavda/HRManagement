class ChangeExpenseDescriptionToText < ActiveRecord::Migration[8.0]
  def change
    change_column :expenses, :description, :text, null: true
  end
end
