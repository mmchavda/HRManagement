class CreateNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :notes do |t|
      t.text :content
      #t.references :ticket, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :notable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
