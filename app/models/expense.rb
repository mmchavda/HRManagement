class Expense < ApplicationRecord
  audited except: [:amount, :date]
  belongs_to :user # User who submitted the expense
  has_one :reimbursement_request, dependent: :destroy # Each expense can have one reimbursement request
  has_many_attached :proofs
  validate :proof_format

  validates :title, presence: true
  validates :amount, presence: true
  validates :date, presence: true
  validates :category, presence: true
  validates :proofs, presence: true, on: :create

  # Expense categories could be stored as a string, or an enum for predefined categories
  enum :category, [:travel, :meals, :office_supplies, :certifications, :training, :internet, :fuel, :misc] # Example categories: Office Supplies, Certifications, Training, Other
  private 

  def proof_format
    return unless proofs.attached?

    proofs.each do |file|
      unless file.content_type.in?(%w[image/png image/jpg image/jpeg])
        errors.add(:proofs, 'must be a PNG, JPG, or JPEG image')
      end
    end
  end

end
