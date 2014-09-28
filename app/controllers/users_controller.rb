class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user_data = params.require(:user).permit :email, :initial_card_number
    initial_card = user_data.delete :initial_card_number
    @user = User.new user_data
    if initial_card
      @user.cards.build(number: initial_card)
    end
    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end
end
