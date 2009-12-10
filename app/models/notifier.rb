class Notifier < ActionMailer::Base

  def signup_thanks(user,workshop)
    recipients user.email
    from "Art Photo Workshops <info@artphotoworkshops.com>"
    subject "You're registered for #{workshop.name}!"

    body  :first_name => user.first_name,
          :workshop_name => workshop.name,
          :cost => workshop.cost
  end

  def headsup_signup(user,workshop)
    recipients 'info@artphotoworkshops.com'
    from "Art Photo Workshops <info@artphotoworkshops.com>"
    subject "#{user.first_name} #{user.last_name} registered for #{workshop.name}!"

    body  :user => user,
          :workshop_name => workshop.name
  end

  def forgot_password(user, newpass)
    recipients user.email
    from "Art Photo Workshops <info@artphotoworkshops.com>"
    subject "Forgot your password on ArtPhotoWorkshops.com?"

    body  :first_name => user.first_name,
          :newpass => newpass
  end

end
