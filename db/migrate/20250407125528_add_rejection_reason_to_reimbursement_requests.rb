class AddRejectionReasonToReimbursementRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :reimbursement_requests, :rejection_reason, :string
  end
end
