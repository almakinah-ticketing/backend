class Attendee < ApplicationRecord
  include Validatable
  include Confirmable

  has_many :tickets, dependent: :destroy
end
