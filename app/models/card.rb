class Card < ActiveRecord::Base
  belongs_to :user
  has_one :card_info

  validates :number, presence: true, format: {with: /\A[0-9]{8}\z/}, uniqueness: true  
end
