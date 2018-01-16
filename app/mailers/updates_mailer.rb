class UpdatesMailer < ApplicationMailer
  def updates_mail(attendee, event)
    @event = event
    @attendee = attendee
    mail from: 'almakinahsummit@gmail.com', to: attendee.email, subject: "Updates to #{event.title}"
  end
end
