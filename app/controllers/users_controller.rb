class UsersController < ApplicationController

  def index 
    # @users = User.order(:id).all
    @users = User.order(created_at: :desc).all 
  end

  def show 
    user_id = params[:id]
    @user = User.find_by(id: user_id)

    if @user.nil? 
      render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
      return 
    end
  end

  def login_form 
    @user = User.new
  end

  def login
    username = params[:user][:name]
    user = User.find_by(name: username)

    if user.nil? 
      user = User.new(name: params[:user][:name])

      if !user.save 
        flash[:warning] = "Unable to login"
        redirect_to root_path 
        return 
      end 

      flash[:success] = "Welcome #{user.name}"
    else  
      flash[:success] = "Successfully logged in as existing user #{user.name} :D"
    end

    session[:user_id] = user.id  
    redirect_to root_path
  end

  def current 
    @current_user = User.find_by(id: session[:user_id])

    unless @current_user 
      flash[:error] = "You must be logged in to see this page"
      redirect_to root_path 
      return 
    end
  end

  def logout 
    if session[:user_id]
      user = User.find_by(id: session[:user_id]) 

      unless user.nil?
        session[:user_id] = nil 
        flash[:success] = "Goodbye #{user.name} 👋"
      
      else 
        session[:user_id] = nil 
        flash[:warning] = "Error Unknown user"
      end 

    else  
      flash[:warning] = "You must be logged in to logout"
    end

    redirect_to root_path
  end
end
