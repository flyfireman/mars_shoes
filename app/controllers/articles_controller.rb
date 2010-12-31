class ArticlesController < ApplicationController
  def index
    if params[:category_id]
      @records = Article.paginate(:page => params[:page],
        :per_page => params[:pre_page] || 3,
        :include => :user,
        :conditions => "#{params[:category_id].to_i}And published = true",
        :order=>"published_at DESC")
    else
      @records = Article.find_all_by_published(true)
      @records = Article.paginate(:page => params[:page],
        :per_page => params[:pre_page] || 3,
        :include => :user,
        :conditions => "published = true",
        :order=>"published_at DESC")
    end
    respond_to do |wants|
      wants.html
      wants.xml { render :xml => @records.to_xml}
      wants.rss {render :action => 'rss.rxml', :layout => false}
      wants.atom {render :action => 'atom.rxml', :layout => false}
    end
  end
  
  def show
    @record = Article.find(params[:id])
  end
  
  def new
    @record = Article.new
  end
  
  def create
    @record = Article.new(params[:article])
    if @record.save
      flash[:notice] = "Successfully created article."
      redirect_to @record
    else
      render :action => 'new'
    end
  end
  
  def edit
    @record = Article.find(params[:id])
  end
  
  def update
    @record = Article.find(params[:id])
    if @record.update_attributes(params[:article])
      flash[:notice] = "Successfully updated article."
      redirect_to @record
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @record = Article.find(params[:id])
    @record.destroy
    flash[:notice] = "Successfully destroyed article."
    redirect_to articles_url
  end
end
