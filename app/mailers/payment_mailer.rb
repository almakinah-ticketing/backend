class PaymentMailer < ApplicationMailer
  def payment_mail(attendee, event, num_tickets)
    @event = event
    @attendee = attendee
    @num_tickets = num_tickets
    mail from: 'almakinahsummit@gmail.com', to: attendee.email, subject: "Booking Confirmation for #{event.title}"
  end
end