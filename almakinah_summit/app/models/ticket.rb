class Ticket < ApplicationRecord
    belongs_to :type
    belongs_to :event
    belongs_to :attendee

    ## scopes
    #  scope :of_event, -> (id) { where(event_id: id) }
end
