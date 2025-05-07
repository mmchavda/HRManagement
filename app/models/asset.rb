class Asset < ApplicationRecord
  has_many :notes, as: :notable, dependent: :destroy
  has_many_attached :documents
  has_many :asset_assignments, dependent: :destroy
  belongs_to :asset_category
  has_one :current_assignment, -> { where(active: true) }, class_name: 'AssetAssignment'

  enum :status, [ :available, :assigned, :scrapped, :in_maintenance ] 
#  enum :condition, [ :new, :good, :damaged ]

  audited except: [:purchase_date, :warranty_expiry]

  validates :unique_id, presence: true
  validates :name, presence: true
  validates :asset_category_id, presence: true
  validates :status, presence: true
  validates :unique_id, uniqueness: true
  
end
