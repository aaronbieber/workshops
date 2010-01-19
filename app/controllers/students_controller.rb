class StudentsController < ApplicationController
  before_filter :authenticate, :only => [:view,:unregister,:paid,:unpaid]

  def login
    @email = params[:student_email]
    @workshop = params[:workshop] || nil
    if request.post?
      if session[:user] = Student.authenticate(params[:student_email], params[:student_password])

        # If the user has a temporary password, prompt them to change it.
        if !session[:user].new_password.nil? and !session[:user].new_password_date.nil?
          redirect_to :controller => 'students', :action => 'change_password'
        else

          # When you're logging in from a workshop page to register quickly, @workshop
          # will be present; go to the existing user registration page. Else, go back
          # to the front page.
          if @workshop
            redirect_to :controller => 'register', :action => 'existing'
          else
            redirect_to :controller => 'upcoming', :action => 'view'
          end
        end
      else
        if Student.exists?(:email => params[:student_email])
          student = Student.find_by_email(params[:student_email])
          flash.now[:error] = 'Your password isn\'t correct. If you\'ve forgotten it, <a href="/students/forgot/'+student.id.to_s+'">click here and we\'ll e-mail it to you</a>.'
        else
          flash.now[:error] = 'Sorry, I couldn\'t find that login. Make sure you\'ve entered everything correctly!'
        end
      end
    end
  end

  def change_password
    if request.post?
      @student = Student.find(session[:user].id)
      @student.update_attributes(params[:student])
      if @student.valid?
        @student.new_password = nil
        @student.new_password_date = nil
        session[:user] = @student
        redirect_to :controller => 'upcoming', :action => 'view'
      end
    else
      @student = Student.new
    end
  end
  
  def logout
    session[:user] = nil
    redirect_to :controller => 'upcoming', :action => 'view'
  end

  def create
  end

  def forgot
    @sent = false
    if request.post?
      if @student = Student.find_by_email(params[:student_email])
        @sent = true
        newpass = @student.create_new_password
        Notifier.deliver_forgot_password(@student, newpass)
      else
        flash.now[:error] = 'The e-mail address you entered wasn\'t found. Try again?'
        @student = Student.new
      end
    else
      @student = Student.new
    end
  end

  ## Administrative functions

  def view
    if params[:id] and Workshop.exists?(params[:id]) and @workshop = Workshop.find(params[:id])
      @students = @workshop.students
    else
      @workshop = nil
      @students = Student.find(:all)
    end
  end

  def export
    if params[:id] and Workshop.exists?(params[:id]) and workshop = Workshop.find(params[:id])
      if params[:type] == 'paid'
        students = workshop.students.select { |s| s.paid(workshop.id) }
      elsif params[:type] == 'unpaid'
        students = workshop.students.select { |s| !s.paid(workshop.id) }
      else
        students = workshop.students
      end
    else
      students = Student.find(:all)
    end

    csv = "\"First Name\",\"Last Name\",\"Email\"\n"
    students.each do |student|
      csv << '"' + student.first_name.gsub(/"/, '""') + '","' + student.last_name.gsub(/"/, '""') + '","' + student.email + "\"\n"
    end

    send_data(csv,
      :type => 'text/csv; charset=utf-8; header=present',
      :filename => 'csv.csv')
  end

  def unregister
    if params[:id] and params[:workshop] and reg = Student.find(params[:id]).registrants.find_by_workshop_id(params[:workshop])
      reg.destroy
    end
    
    # View students expects the workshop ID rather than student ID.
    redirect_to :action => 'view', :id => params[:workshop]
  end

  def paid
    if params[:id] and params[:workshop] and reg = Student.find(params[:id]).registrants.find_by_workshop_id(params[:workshop])
      reg.payment_received = Date.today
      reg.save
    end
    
    # View students expects the workshop ID rather than student ID.
    redirect_to :action => 'view', :id => params[:workshop]
  end

  def unpaid
    if params[:id] and params[:workshop] and reg = Student.find(params[:id]).registrants.find_by_workshop_id(params[:workshop])
      reg.payment_received = nil
      reg.save
    end
    
    # View students expects the workshop ID rather than student ID.
    redirect_to :action => 'view', :id => params[:workshop]
  end

  def delete
    if params[:id]
      Student.delete(params[:id])
      Registrant.delete_all([ "student_id = ?", params[:id] ])

      # View students expects the workshop ID rather than student ID.
      redirect_to :action => 'view', :id => params[:workshop]
    end
  end
end
