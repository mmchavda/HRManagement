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
  scope :hold, -> { where(status: 'hold') }
  scope :rejected, -> { where(status: 'rejected') }
  scope :closed, -> { where(status: 'closed') }

  # Status and priority defaults can be managed via enum
  enum :status, [ :open, :in_progress, :resolved, :hold, :rejected, :closed ]
  enum :priority, [ :low, :medium, :high ]

  #has_many :notes, dependent: :destroy
  has_many :notes, as: :notable, dependent: :destroy

  before_create :assign_hr_user_and_open_status

  private

  def assign_hr_user_and_open_status
    # Find the HR user
    hr_user = User.find_by_role(:hr)
    
    if hr_user
      # Assign the HR user to the ticket and set status to "open"
      self.assigned_user_id = hr_user.id
      self.status = "open"
    else
      # Optionally handle the case where no HR user is found
      Rails.logger.error "No HR user found to assign the ticket to."
    end
  end
end
