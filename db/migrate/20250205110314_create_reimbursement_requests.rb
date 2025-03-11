class CreateReimbursementRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :reimbursement_requests do |t|
      t.decimal :total_amount, precision: 10, scale: 2
      t.integer :status
      t.references :expense, foreign_key: true # Expense associated with the reimbursement
      t.references :manager, foreign_key: { to_table: :users } # Manager who approves the request

      t.timestamps
    end
  end
end
