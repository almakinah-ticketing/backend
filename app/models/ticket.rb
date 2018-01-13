class Ticket < ApplicationRecord
    belongs_to :type
    belongs_to :attendee
    belongs_to :event

    scope :history_charge, -> (attendee_id) { Ticket.where('tickets.attendee_id=?',attendee_id).pluck(:charge)}
end
