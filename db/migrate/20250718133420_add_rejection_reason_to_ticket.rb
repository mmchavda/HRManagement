class AddRejectionReasonToTicket < ActiveRecord::Migration[8.0]
  def change
    add_column :tickets, :rejection_reason, :string
  end
end
