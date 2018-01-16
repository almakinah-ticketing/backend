class Ticket < ApplicationRecord
    belongs_to :type
    belongs_to :attendee
    belongs_to :event

    scope :history_charge, -> (attendee_id) { Ticket.where('tickets.attendee_id=?',attendee_id).pluck(:charge)}
    scope :history_id, -> (attendee_id) { Ticket.where('tickets.attendee_id=?',attendee_id).pluck(:id)}

    def self.buy!(type_ids, event_id, charge_id, attendee_id)
      attendee = Attendee.find attendee_id
      event = Event.find event_id

      type_ids.each do |type|
        Ticket.create!(attendee: attendee, type_id: type, event: event, charge: charge_id)
      end

      num_tickets = type_ids.length

      PaymentMailer.payment_mail(attendee, event, num_tickets).deliver_now
    end
end