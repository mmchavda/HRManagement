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

  validates :email, presence: true
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "Invalid email format" }, if: :email_present?

  validates :password, format: { 
    with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}\z/, 
    message: "must include at least one lowercase letter, one uppercase letter, and one digit" 
  }, if: :password_present?

  # Roles: Admins, Agents, and Users can be defined here
	enum :role, [:employee, :hr, :admin, :manager, :lead]
  has_one_attached :avatar

  after_create :set_default_role

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
