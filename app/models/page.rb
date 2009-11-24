class Page < ActiveRecord::Base
  validates_presence_of :title, :name, :text
  validates_format_of :name, :with => /^[^\s]*$/, :message => 'cannot contain spaces'
  
  def text(usehtml = false)
    d = read_attribute(:text).dup
    if usehtml
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
    else
      d
    end
  end
end
