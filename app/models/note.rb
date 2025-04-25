class Note < ApplicationRecord
  belongs_to :notable, polymorphic: true
  belongs_to :user
  #belongs_to :ticket
 # belongs_to :user # This creates the relationship between notes and users
  
  validates :content, presence: true
end
