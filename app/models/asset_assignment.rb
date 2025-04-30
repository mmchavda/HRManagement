class AssetAssignment < ApplicationRecord
  #audited associated_with: :asset
  audited associated_with: :asset, except: [:assigned_at, :returned_at]

  # Associations
  belongs_to :user
  belongs_to :asset
end
