class WorkshopsController < ApplicationController
  before_filter :authenticate

  def create
    if request.post?
      @workshop = Workshop.new(params[:workshop])
      if params[:preview]
        @preview = true
      else
        if @workshop.valid?
          @workshop.save
          redirect_to :controller => 'admin'
        end
      end
    else
      @workshop = Workshop.new()
    end
  end

  def edit
    if request.post?
      if params[:commit]
        @workshop = Workshop.update(params[:id], params[:workshop])
        if @workshop.valid?
          redirect_to :controller => 'admin'
        end
      elsif params[:preview]
        @workshop = Workshop.update(params[:id], params[:workshop])
        @workshop.ancestor = params[:ancestor]
        @preview = true
        @workshop.valid?
      end
    else
      @workshop = Workshop.find(params[:id])
    end
  end

  def activate
    shop = Workshop.find(params[:id])
    shop.active = true
    shop.save
    redirect_to :controller => 'admin'
  end

  def deactivate
    shop = Workshop.find(params[:id])
    shop.active = false
    shop.save
    redirect_to :controller => 'admin'
  end

  def delete
    Workshop.delete(params[:id])
    redirect_to :controller => 'admin'
  end

  def duplicate
    if workshop = Workshop.find(params[:id])
      w = Workshop.new(workshop.attributes)
      w.active = false
      w.ancestor = workshop.id
      w.save
    end
    redirect_to :controller => 'admin'
  end

end
