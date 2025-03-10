class ReimbursementRequest < ApplicationRecord
  belongs_to :expense # Each reimbursement request is for a specific expense
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id' # The manager who approves/rejects the request

  # Status for reimbursement request
  enum :status, [:pending, :approved, :rejected]

end
