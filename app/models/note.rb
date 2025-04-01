class Note < ApplicationRecord
  belongs_to :ticket
  belongs_to :user # This creates the relationship between notes and users
  
  validates :content, presence: true
end
