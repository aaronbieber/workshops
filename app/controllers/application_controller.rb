# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :location

  def authenticate
    if not session[:admin]
      redirect_to :controller => 'admin', :action => 'login'
    end
  end
  
  def location
    session[:stack] = [] if not session[:stack]
    session[:stack].push(request.request_uri)
    session[:stack].pop if session[:stack].size > 5
    @previous_page = previous_page
  end

  def previous_page
    if session[:stack].size > 1 and session[:stack][session[:stack].size - 1] != request.request_uri
      session[:stack][session[:stack].size - 1]
    end
  end

  def login_required
    if session[:user]
      return true
    end
    flash[:warning] = 'Please log in to continue.'
    session[:return_to] = request.request_uri
    redirect_to :controller => 'register', :action => 'existing'
    return false
  end

  def current_user
    session[:user]
  end

  def redirect_to_stored
    if return_to = session[:return_to]
      session[:return_to] = nil
      redirect_to_url(return_to)
    else
      redirect_to :controller => 'upcoming', :action => 'view'
    end
  end

end
