class UsersController < ApplicationController

  def index 
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
    @user = User.find_by(name: username)
    

    if @user.nil? 
      @user = User.new(user_params)
      
      if @user.save 
        flash[:success] = "Welcome #{@user.name}"
      else
        flash.now[:warning] = "A problem occurred: Could not log in"
        render :login_form
        return 
      end 
    else  
      flash[:success] = "Successfully logged in as existing user #{@user.name} :D"
    end

    session[:user_id] = @user.id  
    redirect_to root_path
  end

  def logout 
    user = User.find_by(id: session[:user_id]) 

    if user
      unless user.nil?
        session[:user_id] = nil 
        flash[:success] = "Goodbye #{user.name} 👋"
      
      else 
        session[:user_id] = nil 
        flash[:warning] = "Error Unknown user"
      end 
    end

    redirect_to root_path
  end

  private 

  def user_params 
    return params.require(:user).permit(:name)
  end
end
