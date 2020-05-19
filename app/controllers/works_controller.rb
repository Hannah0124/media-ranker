class WorksController < ApplicationController

  def index 
    # @works = Work.all
    @works = Work.sort_by_vote_counts
  end

  def show 
    work_id = params[:id]
    @work = Work.find_by(id: work_id)

    if @work.nil?
      render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
      return 
    end
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
    work_id = params[:id]
    @work = Work.find_by(id: work_id) 

    if @work.nil? 
      render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
      return  
    end 
  end

  def update 
    work_id = params[:id]
    @work = Work.find_by(id: work_id)

    if @work.nil?
      render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
      return 
    elsif @work.update(work_params)
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
    work_id = params[:id]
    @work = Work.find_by(id: work_id)

    if @work.nil?
      render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
      return 
    else 
      @work.destroy 
      flash[:success] = "Successfully destroyed album #{@work.id}"
      redirect_to works_path 
      return
    end
  end

  private 

  def work_params 
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end
end