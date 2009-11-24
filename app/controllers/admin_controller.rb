class AdminController < ApplicationController
  before_filter :authenticate, :except => :login

  def index
    params[:page] = params[:page] || 1
    params[:tense] = params[:tense] || 'future'
    if params[:tense] and params[:tense] == 'past'
      @workshops = Workshop.paginate :page => params[:page], :conditions => [ 'start_date < ?', Date.today ], :order => "start_date DESC"
    elsif params[:tense] and params[:tense] == 'future'
      @workshops = Workshop.paginate :page => params[:page], :conditions => [ 'start_date >= ?', Date.today ], :order => "start_date DESC"
    end
    @pages = Page.find(:all)
  end

  def login
    @email = params[:email] || ''
    if request.post?
      if session[:admin] = Administrator.authenticate(params[:email], params[:pass])
        redirect_to :action => 'index'
      else
        flash[:error] = 'Incorrect login!'
      end
    end
  end

  def logout
    session[:admin] = nil
    redirect_to :controller => 'upcoming', :action => 'view'
  end

  def activate
    if @object == 'workshop' and params[:id]
      shop = Workshop.find(params[:id])
      shop.active = true
      shop.save
      home
    end
  end

  def deactivate
    if @object == 'workshop' and params[:id]
      shop = Workshop.find(params[:id])
      shop.active = false
      shop.save
      home
    end
  end

  private

  def page_edit
    if request.post?
      if params[:commit]
        if params[:id]
          @page = Page.update(params[:id], params[:page])
          if not @page.valid?
            render :template => 'admin/page_edit'
          else
            home
          end
        else
          home
        end
      elsif params[:preview]
        @preview = true
        @page = Page.new(params[:page])
        @page.id = params[:id]
        @page.valid?
        render :template => 'admin/page_edit'
      end
    else
      if params[:id]
        @page = Page.find(params[:id])
        render :template => 'admin/page_edit'
      else
        home
      end
    end
  end

  def page_create
    if request.post?
      @page = Page.new(params[:page])
      if not @page.valid?
        render :template => 'admin/page_create'
      else
        @page.save
        home
      end
    else
      @page = Page.new()
      render :template => 'admin/page_create'
    end
  end

  def workshop_edit
    if request.post?
      if params[:commit]
        if params[:id]
          @workshop = Workshop.update(params[:id], params[:workshop])
          if not @workshop.valid?
            render :template => 'admin/workshop_edit'
          else
            home
          end
        else
          flash[:error] = 'Something has gone horribly wrong.'
          render :template => 'admin/workshop_edit'
        end
      elsif params[:preview]
        @preview = true
        @workshop = Workshop.new(params[:workshop])
        @workshop.id = params[:id]
        @workshop.valid?
        render :template => 'admin/workshop_edit'
      end
    else
      if params[:id]
        @workshop = Workshop.find(params[:id])
        render :template => 'admin/workshop_edit'
      else
        home
      end
    end
  end

  def workshop_create
    if request.post?
      @workshop = Workshop.new(params[:workshop])
      if not @workshop.valid?
        render :template => 'admin/workshop_create'
      else
        #@workshop.active = 1 if params[:workshop][:active]
        @workshop.save
        home
      end
    else
      @workshop = Workshop.new()
      render :template => 'admin/workshop_create'
    end
  end

  def authenticate
    if not session[:admin]
      redirect_to :action => 'login'
    end
  end

  def get_object
    @object = (defined?(params)) ? (params[:object] || 'home') : 'home'
    if @object == 'logout'
      logout
    end
  end
end
