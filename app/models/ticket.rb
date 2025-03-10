class Ticket < ApplicationRecord
  belongs_to :user # Creator of the ticket
  belongs_to :assigned_user, class_name: 'User', foreign_key: 'assigned_user_id', optional: true # User (agent) assigned to this ticket
  
  has_many :reimbursement_requests, through: :expenses # Related reimbursement requests through associated expenses
  
  # Status and priority defaults can be managed via enum
  enum :status, [ :open, :in_progress, :resolved ]
  enum :priority, [ :low, :medium, :high ]
end
