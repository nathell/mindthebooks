class CardsController < ApplicationController
  before_filter :ensure_logged_in

  def new
    @card = Card.new
  end

  def create
    user = User.find session[:user_id]
    card_data = params.require(:card).permit :number
    @card = Card.new user_id: session[:user_id], number: card_data[:number]
    @card.save
    redirect_to user
  end
end
