class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :created_tickets, class_name: 'Ticket', foreign_key: 'user_id', dependent: :destroy # Tickets created by the user
  has_many :assigned_tickets, class_name: 'Ticket', foreign_key: 'assigned_user_id', dependent: :nullify # Tickets assigned to the user
  has_many :expenses, dependent: :destroy # Expenses submitted by the user
  has_many :reimbursement_requests, through: :expenses # Reimbursement requests related to the user's expenses
  has_many :notes, dependent: :destroy

  belongs_to :team_lead, class_name: 'User', foreign_key: 'tl_id', optional: true
  has_many :team_members, class_name: 'User', foreign_key: 'tl_id'

  validates :email, presence: true
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "Invalid email format" }, if: :email_present?

  validates :password, format: { 
    with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}\z/, 
    message: "must include at least one lowercase letter, one uppercase letter, and one digit" 
  }, if: :password_present?

  # Roles: Admins, Agents, and Users can be defined here
	#enum :role, [:employee, :hr, :admin]
  enum :role, [:employee, :tl, :hr, :admin, :operation_head]

  has_one_attached :avatar

  after_create :set_default_role

  # Only allow sign-in if the user is active
  def active_for_authentication?
    super && is_active?
  end

  # Provide a custom message for inactive users
  def inactive_message
    is_active? ? super : :account_inactive
  end

  def set_default_role
    self.update_columns(role: :employee) if self.role.nil?
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin?
    role == 'admin'
  end

  def hr?
    role == 'hr'
  end

  def manager?
    role == 'manager'
  end

  def employee?
    role == 'employee'
  end

  def lead?
    role == 'lead'
  end

  private 

  def email_present?
    email.present?
  end

  def password_present?
    password.present?
  end
end
