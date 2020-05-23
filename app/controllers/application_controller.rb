class ApplicationController < ActionController::Base

  before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
  around_action :require_login, only: [:logout], if: -> { current_user.nil? }

  def current_user 
    # Use find_by method with input from sessions variable
    @current_user = User.find_by(id: session[:user_id]) 
  end

  def require_login
    if current_user.nil?
      flash[:warning] = "Sorry! You must be logged in to do that"
      redirect_to login_path
    end 
  end
end
