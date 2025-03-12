class ReimbursementRequest < ApplicationRecord
  belongs_to :expense # Each reimbursement request is for a specific expense
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id', optional: true # The manager who approves/rejects the request

  # Status for reimbursement requests can be pending, approved, or rejected
  enum :status, [:pending, :approved, :rejected]

  def approve!
    update(status: 'approved')
  end

  def reject!
    update(status: 'rejected')
  end
end
