class Type < ApplicationRecord
  belongs_to :event
  has_many :tickets, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: {minimum: 1, maximum: 20}, format: {with: /[A-Z]+\w*/}
  validates :price, presence: true, numericality: true
  validates :capacity, presence: true, numericality: true

  # tickets available per type
  def tickets_available_per_type
  sold_tickets = Ticket.where(type_id: self.id).count
  current_capacity = self.capacity
  available_ticket = current_capacity - sold_tickets
  return available_ticket
  end

  def tickets_sold_per_type
    sold_tickets = Ticket.where(type_id: self.id).count
  end
end
