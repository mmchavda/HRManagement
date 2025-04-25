class CreateAssetCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :asset_categories do |t|
      t.string :name, null: false, index: { unique: true }
      t.text :description
      t.timestamps
    end
  end
end
