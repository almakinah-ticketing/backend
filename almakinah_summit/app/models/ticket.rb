class Ticket < ApplicationRecord
  belongs_to :attendee
  belongs_to :type
end
