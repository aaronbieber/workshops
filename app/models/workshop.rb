class Workshop < ActiveRecord::Base
  has_many :registrants
	has_many :students, :through => :registrants
	
	validates_presence_of :name, :max_students, :cost, :description, :if => Proc.new { |w| w.ancestor.nil? }
  validates_presence_of :cutoff_date, :short_name, :start_date, :end_date

  validates_format_of :short_name, :with => /^[^\s]*$/, :message => 'cannot contain spaces'

  def self.per_page
    10
  end
	
	def year
	  self.start_date.year
  end
  
  def month
    Date::MONTHNAMES[self.start_date.month]
  end
  
  def ident
    self.short_name
  end

	def date_range
		if self.start_date == self.end_date
			"#{Date::MONTHNAMES[self.start_date.month]} #{self.start_date.day}, #{self.start_date.year}"
		else
			"#{Date::MONTHNAMES[self.start_date.month]} #{self.start_date.day}, #{self.start_date.year} - " +
			"#{Date::MONTHNAMES[self.end_date.month]} #{self.end_date.day}, #{self.end_date.year}"
		end
	end

#  def short_name
#    if read_attribute(:short_name).empty? and !self.ancestor.nil?
#      self.ancestor.short_name
#    else
#      read_attribute(:short_name)
#    end
#  end

  def name
    if read_attribute(:name).empty? and !self.ancestor.nil?
      self.ancestor.name
    else
      read_attribute(:name)
    end
  end
  
  def full
    # Count up all the registered students who have actually paid and
    # compare THAT to the max. students. Kids who don't pay don't save
    # a seat!
    if read_attribute(:full)
      true
    else
      self.registrants.select { |r| !r.payment_received.nil? }.size == self.max_students
    end

    #self.students.count == self.max_students
  end

  def cost
    if read_attribute(:cost).nil? and !self.ancestor.nil?
      self.ancestor.cost
    else
      read_attribute(:cost)
    end
  end

  def max_students
    if read_attribute(:max_students).nil? and !self.ancestor.nil?
      self.ancestor.max_students
    else
      read_attribute(:max_students)
    end
  end
  
  def students_paid
    # How many kids paid?
    self.registrants.select { |r| !r.payment_received.nil? }
  end
  
  def thumbnail
    if read_attribute(:thumbnail).empty? and !self.ancestor.nil?
      return self.ancestor.thumbnail
    else
      path = read_attribute(:thumbnail)
    end

    if path.match(/^http/)
      "<div class=\"one-image\"><img src=\"#{path}\" alt=\"\" /></div>"
    elsif path.match(/^\//)
      http = Net::HTTP.new('www.fisheyegallery.com')
      http.start
      resp,data = http.get("/main.php?g2_view=imageblock.External&g2_blocks=specificItem&g2_show=none&g2_item=#{path}")
      http.finish
      data

#     I'm not sure if this works?
      tag = data.match(/<img.*?>/)[0]
      "<div class=\"one-image\">#{tag}</div>"
    end
  end
  
  def length
    self.end_date - self.start_date + 1
  end
  
  def short_desc(usehtml = false)
    if read_attribute(:short_desc).empty? and !self.ancestor.nil?
      return self.ancestor.short_desc(usehtml)
    else
      d = read_attribute(:short_desc).dup
    end

    if usehtml
      r = RedCloth.new d
      r.to_html
    else
      d
    end
  end

  def description(usehtml = false)
    if read_attribute(:description).empty? and !self.ancestor.nil?
      return self.ancestor.description(usehtml)
    else
      d = read_attribute(:description).dup
    end

    if usehtml
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      register = ''
      1.upto(10) { |i| register << chars[rand(chars.size-1)] }
      d.gsub!(/\$register\$/, register)
  
      # Allow the creation of image blocks by simple URLs:
      # 
      # $left:http://server.com/image.jpg$
      # $right:http://server.com/image.jpg$
      # 
      # At the moment, images are EXPECTED to be 200 pixels square. I know that
      # might be limiting, but the objects are floated with margins and that's just
      # how it has to be, OK?
      # 
      d.gsub!(/^\$(left|right):(.*?)(\((.*?)\))?\$\s*$/) do |m|
        "<div class=\"one-image" +
        (($1.downcase == 'left') ? " align-left\" style=\"float: left;\"" : " align-right\" style=\"float: right;\"") +
        "><img src=\"#{$2}\" alt=\"\" />" +
        (($4) ? "<h4 class=\"giDescription\">#{$4}</h4>" : "") +
        "</div>\n"
      end

      # Allow the creation of image blocks by Fisheye Gallery path:
      # 
      # $image:left/Places/DeathValley/Tendrils.jpg$
      # $image:right/Places/DeathValley/Tendrils.jpg$
      # 
      d.gsub!(/^\$image:(left|right)(\/.*?)\$\s*$/) do |m|
        http = Net::HTTP.new('www.fisheyegallery.com')
        http.start
        resp,data = http.get("/main.php?g2_view=imageblock.External&g2_blocks=specificItem&g2_show=title&g2_item=#{$2}&g2_align=#{$1}")
        http.finish
        data.gsub(/(giDescription">[^<]*?)\s*(<\/h4>)/, '\1, by A. Bieber\2')
        # "http://www.fisheyegallery.com/main.php?g2_view=imageblock.External&g2_blocks=specificItem&g2_show=title&g2_item=#{$2}&g2_align=#{$1}"
      end

      r = RedCloth.new d
      r = r.to_html
      r.gsub(register, '<a href="#a">Register now!</a>')
    else
      d
    end
  end

  def ancestor
    (self.ancestor_id.nil?) ? nil : Workshop.find(self.ancestor_id)
  end

  def ancestor=(a)
    if a.is_a? Workshop
      self.ancestor_id = a.id
    elsif a.is_a? Fixnum
      self.ancestor_id = a
    end
  end
end
