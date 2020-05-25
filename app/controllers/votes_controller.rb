class VotesController < ApplicationController

  def upvote
    current_user = User.find_by(id: session[:user_id]) 
    @work = Work.find_by(id: params[:work_id])


    if current_user.nil?
      flash[:warning] = "A problem occured: You must log in to do that :("

      redirect_back(fallback_location: root_path)
      return 
    end 

    
    # raise
    if @work.nil? 
      render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
      return 
    end  

    if Vote.upvoted?(@work.id, current_user.id)
      flash[:warning] = "A problem occurred: Could not upvote, user: has already voted for this work"
      redirect_back(fallback_location: root_path)
      return  

    else 
      Vote.create(work_id: @work.id, user_id: current_user.id)
      flash[:success] = "Successfully upvoted!"

      redirect_back(fallback_location: root_path)
      return
    end 
  end
end

# redirect to the previous page - reference: 
# https://stackoverflow.com/questions/2139996/how-to-redirect-to-previous-page-in-ruby-on-rails

# https://blog.bigbinary.com/2016/02/29/rails-5-improves-redirect_to_back-with-redirect-back.html
