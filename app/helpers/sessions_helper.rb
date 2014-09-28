module SessionsHelper
  def logged_in?
    !session[:user_id].nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find session[:user_id]
  end

  def ensure_logged_in
    unless logged_in?
      redirect_to login_path 
    end
  end

  def ensure_correct_user
    unless params[:id] == session[:user_id].to_s
      redirect_to login_path
    end
  end
end
