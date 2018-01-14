class PaymentMailer < ApplicationMailer
  def payment_mail(attendee_email, event)
    @event = event
    mail from: 'lara.aasem@aucegypt.edu', to: attendee_email, subject:'Payment'
  end
end
