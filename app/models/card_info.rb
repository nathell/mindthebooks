class CardInfo < ActiveRecord::Base
  belongs_to :card
  has_many :books
end
