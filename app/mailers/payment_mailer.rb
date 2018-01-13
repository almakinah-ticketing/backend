class PaymentMailer < ApplicationMailer
  def payment_mail(attendee_email, event)
    @event = event
    mail from: 'admin@almakinah.com', to: attendee_email, subject:'Payment'
  end
end
