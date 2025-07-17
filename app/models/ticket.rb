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
  scope :reopened, -> { where(status: 'reopened') }
  scope :accidental, -> { where(status: 'accidental') }

  # Status and priority defaults can be managed via enum
  enum :status, [ :open, :in_progress, :resolved, :hold, :rejected, :closed, :reopened, :accidental ]
  enum :priority, [ :low, :medium, :high ]
  # Category can be managed via enum or a separate model
  enum :category, [ :hr, :it ]
  #has_many :notes, dependent: :destroy
  has_many :notes, as: :notable, dependent: :destroy
  before_create :assign_ticket_handler
  before_create :set_status

  def assign_hr_user_and_open_status
    hr_user = User.find_by(role: :hr)

    if hr_user
      self.assigned_user_id = hr_user.id
    else
      Rails.logger.error "No HR user found to assign the ticket to."
    end
  end

  def assign_hr_user_and_save
    assign_hr_user_and_open_status
    save!
  end

  private

  def assign_ticket_handler
    if user&.team_lead.present?
      assign_to_team_lead
    else
      assign_hr_user_and_open_status
    end
  end

  def assign_to_team_lead
    tl = user.team_lead
    if tl&.tl?
      self.assigned_user_id = tl.id
    else
      Rails.logger.warn("No valid TL found for user ##{user.id}")
    end
  end

  def set_status
    self.status ||= 'open' # Default status is 'open' if not set
  end
end
