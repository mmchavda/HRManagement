class Ticket < ApplicationRecord
  audited

  # belongs_to :user # Creator of the ticket
  belongs_to :assigned_user, class_name: 'User', foreign_key: 'assigned_user_id', optional: true # User (agent) assigned to this ticket
  belongs_to :user, foreign_key: 'user_id' # This would represent the creator of the ticket
  has_many :reimbursement_requests, through: :expenses # Related reimbursement requests through associated expenses
  validates :title, presence: true
  validates :priority, presence: true

  scope :open, -> { where(status: 'open') }
  scope :in_progress, -> { where(status: 'in_progress') }
  scope :resolved, -> { where(status: 'resolved ') }

  # Status and priority defaults can be managed via enum
  enum :status, [ :open, :in_progress, :resolved ]
  enum :priority, [ :low, :medium, :high ]
end
