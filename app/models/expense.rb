class Expense < ApplicationRecord
  audited except: [:amount, :date]
  belongs_to :user # User who submitted the expense
  has_one :reimbursement_request, dependent: :destroy # Each expense can have one reimbursement request
  has_one_attached :proof
  validate :correct_proof_format

  validates :title, presence: true
  validates :amount, presence: true
  validates :date, presence: true
  validates :category, presence: true
  validates :proof, presence: true

  # Expense categories could be stored as a string, or an enum for predefined categories
  enum :category, [:travel, :meals, :office_supplies, :certifications, :training, :other]

  private 

  def correct_proof_format
    return unless proof.attached?

    unless proof.content_type.in?(%('image/png image/jpg image/jpeg'))
      errors.add(:proof, 'must be a PNG, JPG, or JPEG image')
    end
  end
end
