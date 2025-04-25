class AssetAssignment < ApplicationRecord
  audited associated_with: :asset
  belongs_to :user
  belongs_to :asset
end
