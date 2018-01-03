class Admin < ApplicationRecord
  include Validatable
  include Confirmable

  has_many :events, dependent: :destroy
end
