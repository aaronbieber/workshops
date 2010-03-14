# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def get_child_workshops(needle, haystack, net = [], depth = 1)
    hit = false
    haystack.each do |h|
      if h['parent'] == needle
        hit = true
        net = net | get_child_workshops(h['id'], haystack, net, depth + 1) # Union
      end
    end
    net << needle if not hit and depth > 1
    return net
  end

end
