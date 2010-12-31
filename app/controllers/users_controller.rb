class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  #  include AuthenticatedSystem
  before_filter :load_user, :only => [:show, :edit, :update, :destroy]
  before_filter :new_user, :only => :new
 # filter_access_to :all
  #filter_access_to [:show, :edit, :update], :attribute_check => true

  def index
    @records = User.all
  end

  def new;end

  def create
    logout_keeping_session!
    @record = User.new(params[:user])
    success = @record && @record.save
    if success && @record.errors.empty?
      self.current_user = @record # !! now logged in
      redirect_to users_url
      flash[:notice] = "注册成功。"
    else
      flash[:error]  = "注册失败。"
      render :action => 'new'
    end
  end

  def show;end

  def edit;end

  def update
    if @record.update_attributes(params[:user])
      flash[:notice] = "更新用户成功。"
      redirect_to @record
    else
      render :action => 'edit'
    end
  end


  def destroy
    @record.destroy
    flash[:notice] = "删除用户成功。"
    redirect_to users_url
  end
=begin
  # render new.rhtml
  def new
    @record = User.new
  end
 
  def create
    logout_keeping_session!
    @record = User.new(params[:user])

    success = @record && @record.save

    if success && @record.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
=end
  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end

  protected
  def load_user
    @record = User.find params[:id]
  end

  def new_user
    @record = User.new
  end

  def permission_denied
    respond_to do |format|
      flash[:error] = '对不起，您没有足够的权限访问此页！'
      format.html { redirect_to request.referer }
      format.xml  { head :unauthorized }
      format.js   { head :unauthorized }
    end
  end
end
