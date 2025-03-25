class ReimbursementRequest < ApplicationRecord
  audited except: [:total_amount]

  belongs_to :expense # Each reimbursement request is for a specific expense
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id', optional: true # The manager who approves/rejects the request

  validates :status, presence: true

  # Status for reimbursement requests can be pending, approved, or rejected
  enum :status, [:pending, :approved, :rejected]
  scope :pending, -> { where(status: 'pending') }
  scope :approved, -> { where(status: 'approved') }
  scope :rejected, -> { where(status: 'rejected') }

  # Approve or reject a reimbursement request

  def approve!
    update(status: 'approved')
  end

  def reject!
    update(status: 'rejected')
  end
end
