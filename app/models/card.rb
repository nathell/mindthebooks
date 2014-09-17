class Card < ActiveRecord::Base
  belongs_to :user
  has_one :card_info
end
