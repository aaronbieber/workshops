class Student < ActiveRecord::Base
  has_many :registrants
  has_many :workshops, :through => :registrants

  attr_protected :salt, :id
  attr_accessor :password
  attr_accessor :refresh_password
  
  validates_presence_of :first_name, :message => 'Enter your first name.'
  validates_presence_of :last_name, :message => 'Enter your last name.'
  validates_presence_of :address1, :message => 'Enter your address.'
  validates_presence_of :city, :message => 'What city do you live in?'
  validates_presence_of :zip, :message => 'What is your zip code?'
  validates_presence_of :state, :message => 'Please enter a state.'
  validates_presence_of :email, :message => 'We will contact you via e-mail; please enter your address.'

  validates_length_of :password, :within => 8...32,
                      :unless => Proc.new { |s| s.password.empty? },
                      :message => 'Your password must be at least 8 characters, but shorter than 32.'

  validates_presence_of :password, :message => 'Enter a password to protect your account.'
  validates_presence_of :password_confirmation, :unless => Proc.new { |s| s.password_confirmation.nil? }, :message => 'Please enter your password twice.'
  validates_confirmation_of :password,
                            :unless => Proc.new { |s| (s.password_confirmation.nil? or s.password_confirmation.empty?) },
                            :message => 'The two passwords entered don\'t match.'

  validates_uniqueness_of :email, :message => 'The e-mail address entered already exists.'
  validates_format_of :email, :unless => Proc.new { |s| s.email.empty? }, :with => /^\S*@\S*\./, :message => 'The e-mail address entered doesn\'t seem to be valid.'

  validates_format_of :zip, :with => /^\d{5}(\d{4})?$|^[a-z][1-9][a-z]\s?[a-z]{3}$/i,
                      :unless => Proc.new { |s| s.zip.empty? },
                      :message => 'The zip code entered doesn\'t seem to be valid.'

  validates_format_of :phone, :with => /^\d{10}\d?$|^$/, :message => 'The phone number entered doesn\'t appear to be valid.'

  def self.authenticate(email, p)
    user = Student.find(:first, :conditions => [ "email = ?", email ] )
    return nil if user.nil?
    
    # If this user has a new password saved, find out.
    if (p == user.new_password and (user.new_password_date + 3) > Date.today)
      return user
    elsif Student.encrypt(p, user.salt) == user.pass
      # If the user has a temporary password, destroy it.
      user.new_password = nil
      user.new_password_date = nil
      user.save_without_validation

      return user
    end
  end

  def password=(newpass)
    @password=newpass
    self.salt = Student.random_string(10) if !self.salt?
    write_attribute(:pass, Student.encrypt(@password, self.salt) )
  end

  def paid(workshop)
    # Did this student pay for the supplied workshop?
    !self.registrants.find_by_workshop_id(workshop).payment_received.nil?
  end

  def create_new_password
    newpass = self.new_password || Student.random_string(8)
    #self.salt = Student.random_string(10) if !self.salt?
    self.new_password = newpass #Student.encrypt(newpass, self.salt)
    self.new_password_date = Date.today
    self.save_without_validation

    newpass
  end

  protected
  
  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end
  
  def self.random_string(len)
    #generate a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
end
