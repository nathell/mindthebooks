class SessionsController < ApplicationController
  layout "login"

  def new
  end

  def create
    user = User.find_by email: params["sessions"]["email"]
    if user && user.authenticate(params["sessions"]["password"])
      session[:user_id] = user.id
      self.current_user = user
      redirect_to user
    else
      render 'new'
    end
  end

  def destroy
    session.delete :user_id
    render 'new'
  end
end
