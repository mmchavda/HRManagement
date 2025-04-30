class CreateAssetAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :asset_assignments do |t|
      t.references :asset, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :assigned_at
      t.datetime :returned_at
      t.boolean :active, default: true
      t.text :comments
      t.timestamps
    end
  end
end
