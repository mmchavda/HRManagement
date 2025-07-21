class AddDefaultNilToTicket < ActiveRecord::Migration[8.0]
  def change
    change_column_default :tickets, :approved, from: false, to: nil
  end
end
