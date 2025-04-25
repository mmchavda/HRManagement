class Asset < ApplicationRecord
  has_many :notes, as: :notable, dependent: :destroy
  has_many_attached :documents
  has_many :asset_assignments, dependent: :destroy
  belongs_to :asset_category

  enum :status, [ :available, :assigned, :scrapped ]

  audited
end
