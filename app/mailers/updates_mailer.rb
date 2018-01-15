class UpdatesMailer < ApplicationMailer
  def updates_mail(attendee_email, event)
    @event = event
    mail from: 'almakinahsummit@gmail.com', to: attendee_email, subject: 'Updates'
  end
end
