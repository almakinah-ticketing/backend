class Ticket < ApplicationRecord
    belongs_to :type
    belongs_to :attendee
    belongs_to :event
end
