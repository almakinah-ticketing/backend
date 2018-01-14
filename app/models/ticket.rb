class Ticket < ApplicationRecord
    belongs_to :type
    belongs_to :attendee
    belongs_to :event

    scope :history_charge, -> (attendee_id) { Ticket.where('tickets.attendee_id=?',attendee_id).pluck(:charge)}
    scope :history_id, -> (attendee_id) { Ticket.where('tickets.attendee_id=?',attendee_id).pluck(:id)}
    after_create :payment_emails

    def payment_emails
        PaymentMailer.payment_mail(attendee.email, self.event).deliver_now
    end
end
