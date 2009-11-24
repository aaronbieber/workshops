class UpcomingController < ApplicationController

  def view
    @admin = session[:admin]
    if session[:admin]
      @workshops = Workshop.find(:all, 
        :conditions => [ "cutoff_date >= ?", Date.today ],
        :order => "start_date ASC" )
    else
      @workshops = Workshop.find(:all, 
        :conditions => [ "cutoff_date >= ? and active = 1", Date.today ],
        :order => "start_date ASC" )
    end
  end

end
