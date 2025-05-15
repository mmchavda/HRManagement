class AddCategoryToTicket < ActiveRecord::Migration[8.0]
  def change
    add_column :tickets, :category, :int
  end
end
