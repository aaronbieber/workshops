class Administrator < ActiveRecord::Base
	def self.authenticate(email, p)
    user = Administrator.find(:first, :conditions => [ "email = ?", email ] )
    return nil if user.nil?
    return user if Administrator.encrypt(p, user.salt) == user.pass
  end

  def password=(newpass)
    @password=newpass
    self.salt = Administrator.random_string(10) if !self.salt?
    write_attribute(:pass, Administrator.encrypt(@password, self.salt) )
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
