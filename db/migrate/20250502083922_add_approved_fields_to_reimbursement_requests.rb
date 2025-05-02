class AddApprovedFieldsToReimbursementRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :reimbursement_requests, :approved_at, :date
    add_column :reimbursement_requests, :approved_by, :integer
  end
end
