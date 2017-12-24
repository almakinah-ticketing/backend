class Event < ApplicationRecord
  belongs_to :category
  validates :title, presence: true
  validates :overview, presence: true
  validates :event_date, presence: true
  validates :duration, presence: true
  has_many :types, dependent: :destroy
end
