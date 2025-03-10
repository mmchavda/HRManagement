class CreateTickets < ActiveRecord::Migration[8.0]
  def change
    create_table :tickets do |t|
      t.string :title
      t.text :description
      t.integer :status 
      t.integer :priority
      t.references :user, foreign_key: true # User who created the ticket
      t.references :assigned_user, foreign_key: { to_table: :users } # User (agent) assigned to the ticket

      t.timestamps
    end
  end
end