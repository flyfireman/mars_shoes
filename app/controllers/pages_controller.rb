class PagesController < ApplicationController
  def index
    @records = Page.paginate(:page => params[:page],
      :per_page => params[:pre_page] || 3,
      # :conditions=>["status = 'new'"],
      :order=>"created_at DESC")
  end
  
  def show
    @record = Page.find(params[:id])
  end
  
  def new
    @record = Page.new
  end
  
  def create
    @record = Page.new(params[:page])
    if @record.save
      flash[:notice] = "Successfully created page."
      redirect_to @record
    else
      render :action => 'new'
    end
  end
  
  def edit
    @record = Page.find(params[:id])
  end
  
  def update
    @record = Page.find(params[:id])
    if @record.update_attributes(params[:page])
      flash[:notice] = "Successfully updated page."
      redirect_to @record
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @record = Page.find(params[:id])
    @record.destroy
    flash[:notice] = "Successfully destroyed page."
    redirect_to pages_url
  end
end
