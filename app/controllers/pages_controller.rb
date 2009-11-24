class PagesController < ApplicationController
  before_filter :authenticate, :except => [:view]
  
  def view
    if params[:name].to_i > 0
      if not @page = Page.find(:first, :conditions => [ "id = ?", params[:name].to_i ])
        redirect_to :controller => 'upcoming', :action => 'view'
      end
    elsif params[:name].is_a?(String)
      if not @page = Page.find(:first, :conditions => [ "name = ?", params[:name] ])
        redirect_to :controller => 'upcoming', :action => 'view'
      end
    end
  end

  def edit
    if request.post?
      if params[:commit]
        @page = Page.update(params[:id], params[:page])
        if @page.valid?
          redirect_to :controller => 'admin'
        end
      elsif params[:preview]
        @preview = true
        @page = Page.new(params[:page])
        @page.id = params[:id]
        @page.valid?
      end
    else
      @page = Page.find(params[:id])
    end
  end

  def create
    if request.post?
      @page = Page.new(params[:page])
      if @page.valid?
        @page.save
        redirect_to :controller => 'admin'
      end
    else
      @page = Page.new()
    end
  end

  def delete
    if params[:id]
      Page.delete(params[:id])
      redirect_to :controller => 'admin'
    end
  end
end
