class Ticket < ApplicationRecord
    belongs_to :type
    belongs_to :attendee
    belongs_to :event

    ## scopes
    #  scope :of_event, -> (id) { where(event_id: id) }
end
