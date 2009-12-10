class RegisterController < ApplicationController
  before_filter :get_workshop

  def view
    # If we couldn't find it or it doesn't exist or something, whoops.
    if @workshop.nil?
      redirect_to :controller => 'upcoming', :action => 'view'
    end
  end
  
  def join
    email = params[:email]
    if email.empty? or email.match(%r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i).nil?
      flash[:error] = 'You need to enter a valid e-mail address!'
      redirect_to :action => 'view'
    else
      if @student = Student.find(:first, :conditions => [ "email = ?", email ] )
        if @workshop.students.include? @student
          render :template => 'register/already_registered'
        else
          redirect_to :controller => 'students', :action => 'login', :workshop => @workshop.id
          #redirect_to :action => 'existing', :sid => @student.id, :year => @workshop.year, :month => @workshop.month, :ident => @workshop.ident
        end
      else
        redirect_to :action => 'create', :email => email, :year => @workshop.year, :month => @workshop.month, :ident => @workshop.ident
      end
    end
  end
  
  def create
    @create = true
    if request.post?
      # It means Student Hash ;-)
      stash     = params[:student]
      
      # Clean up some data
      stash[:zip].gsub!(/[^\d]/, '')
      stash[:state].sub!(/^(..).*$/,'\1').upcase! unless stash[:state].empty?
      stash[:phone].gsub!(/[^\d]/, '')
      stash[:ext].gsub!(/[^\d]/, '')

      @student  = Student.new(stash)

      if not @student.valid?
        render :template => 'register/create'
      else
        @student.save
        @workshop.students << @student unless @workshop.students.include? @student

        session[:user] = @student

        Notifier.deliver_signup_thanks(@student, @workshop)
        Notifier.deliver_headsup_signup(@student, @workshop)
        render :template => 'register/thanks'
      end
    else
      @student = Student.new(:email => params[:email])
    end
  end
  
  def update
    stash     = params[:student]
    sid       = params[:sid]
    @student  = Student.find(params[:sid])
    if @student.update_attributes(stash)
      @workshop.students << @student unless @workshop.students.include? @student

      Notifier.deliver_signup_thanks(@student, @workshop)
      Notifier.deliver_headsup_signup(@student, @workshop)
      render :template => 'register/thanks'
    else
      @go = params[:go] || false
      render :template => 'register/existing'
    end
  end
  
  def existing
    if session[:user]
      if @workshop.students.include? session[:user]
        render :template => 'register/already_registered'
      end
      @student = session[:user]
    else
      @email = ''
    end
  end
  
  private
  
  def get_workshop
    if params[:workshop]
      @workshop = Workshop.find(params[:workshop])
    else
      @admin = session[:admin]
      if params[:year] and params[:month] and params[:ident]
        if session[:admin]
          @workshop = Workshop.find(:first, :conditions => [ "YEAR(start_date) = :year and MONTHNAME(start_date) = :month and short_name = :ident", params ] )
        else
          @workshop = Workshop.find(:first, :conditions => [ "YEAR(start_date) = :year and MONTHNAME(start_date) = :month and short_name = :ident and active = 1", params ] )
        end
      end
    end
  end

end
