class Expense < ApplicationRecord
  belongs_to :user # User who submitted the expense
  has_one :reimbursement_request, dependent: :destroy # Each expense can have one reimbursement request
  has_one_attached :proof

  # Expense categories could be stored as a string, or an enum for predefined categories
  enum :category, [:travel, :meals, :office_supplies, :certifications, :training, :other]
end
