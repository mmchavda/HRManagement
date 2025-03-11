class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :created_tickets, class_name: 'Ticket', foreign_key: 'user_id', dependent: :destroy # Tickets created by the user
  has_many :assigned_tickets, class_name: 'Ticket', foreign_key: 'assigned_user_id', dependent: :nullify # Tickets assigned to the user
  has_many :expenses, dependent: :destroy # Expenses submitted by the user
  has_many :reimbursement_requests, through: :expenses # Reimbursement requests related to the user's expenses

  # Roles: Admins, Agents, and Users can be defined here
	enum :role, [ :employee, :hr, :admin, :manager, :lead]
end
