# FIXME: How do I add fields not backed by database?
class User < ActiveRecord::Base
  has_many :cards
  has_secure_password
  
  def initial_card_number
    @initial_card_number
  end

  def initial_card_number=(card)
    @initial_card_number = card
  end
end
