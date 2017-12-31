class Type < ApplicationRecord
  belongs_to :event
  validates :name, presence: true
  validates :price, presence: true
  validates :capacity, presence: true
  has_many :tickets, dependent: :destroy

  # tickets available per type
  def tickets_available_per_type
        sold_ticket = Ticket.where(type_id: self.id).count
        current_capacity = self.capacity
        available_ticket = current_capacity - sold_ticket
        return available_ticket
  end

end
