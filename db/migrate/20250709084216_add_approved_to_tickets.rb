class AddApprovedToTickets < ActiveRecord::Migration[8.0]
  def change
    add_column :tickets, :approved, :boolean, default: false
  end
end
