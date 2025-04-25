class CreateAssets < ActiveRecord::Migration[8.0]
  def change
    create_table :assets do |t|
      t.string  :unique_id, null: false, index: { unique: true }  # Ensure uniqueness
      t.string  :name, null: false
     # t.string  :category, null: false  # or reference to a separate `asset_categories` table if you want normalization
      t.references :asset_category, null: false, foreign_key: true
      t.string  :brand
      t.string  :model
      t.text    :specifications
      t.string  :serial_number
      t.date    :purchase_date
      t.date    :warranty_expiry
      t.string  :status, null: false, default: "Available"  # Assigned, Available, Scrapped, etc.
      t.string  :condition  # New, Good, Damaged
      t.string  :location
      t.timestamps
    end
  end
end
