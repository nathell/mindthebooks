class UsersController < ApplicationController
  before_filter :ensure_correct_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    user_data = params.require(:user).permit :email, :password, :password_confirmation, :initial_card_number
    initial_card = user_data.delete :initial_card_number
    @user = User.new user_data
    unless initial_card.blank?
      @user.cards.build(number: initial_card)
    end
    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find params["id"]
  end
end
