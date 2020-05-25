class WorksController < ApplicationController
  
  before_action :find_work, only: [:show, :edit, :update, :destroy]
  around_action :render_404, only: [:show, :edit, :update, :destroy], if: -> { @work.nil? }

  def index 
    @works = Work.sort_by_vote
  end

  def show 
  end

  def new 
    @work = Work.new
  end

  def create 
    @work = Work.new(work_params)

    if @work.save 
      flash[:success] = "#{@work.title} was successfully added! 😄"
      redirect_to work_path(@work)
      return 
    else 
      flash.now[:warning] = "A problem occurred: Could not update #{@work.category}"
      render :new 
      return
    end
  end

  def edit 
  end

  def update 

    if @work.update(work_params)
      flash[:success] = "#{@work.title} was successfully edited! 😄"
      redirect_to work_path(@work.id)
      return
    else 
      flash.now[:warning] = "The work was not successfully edited :("
      render :edit 
      return
    end
  end

  def destroy 
    if @work.destroy
      flash[:success] = "Successfully destroyed album #{@work.id}"
      redirect_to works_path 
      return
    end
  end

  private 

  def work_params 
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end

  def find_work
    work_id = params[:id]
    @work = Work.find_by(id: work_id) 
  end

  def render_404 
    render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
    return 
  end
end

# around_action - reference: https://apidock.com/rails/v4.0.2/AbstractController/Callbacks/ClassMethods/after_action