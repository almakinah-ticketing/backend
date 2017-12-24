class Type < ApplicationRecord
  belongs_to :event
  validates :name, presence: true
  validates :price, presence: true
  validates :capacity, presence: true
  has_many :events, dependent: :destroy
end
