class Attend < ApplicationRecord
  belongs_to :user

  validates :worked_day, presence: true

  
end
