class Admin < ApplicationRecord
  include Validatable
  include Confirmable

  has_many :events, dependent: :destroy
  has_many :admin_activities
end
