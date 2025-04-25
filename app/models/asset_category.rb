class AssetCategory < ApplicationRecord
  has_many :assets, dependent: :restrict_with_exception
end
