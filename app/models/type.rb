class Type < ApplicationRecord
  belongs_to :event
  has_many :tickets, dependent: :destroy

  validates :name, presence: true, length: {minimum: 1, maximum: 20}, format: {with: /[A-Z]+\w*/}
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

  def tickets_sold_per_type_per_month
    @counts = Ticket.where(type_id: self.id).group("DATE_TRUNC('month', created_at)").count
    @parsed_counts = {}
    @counts.each do |m|
      @parsed_counts.reverse_merge!({"#{m[0].strftime("%b %Y")}": m[1]})
    end
    return @parsed_counts
  end

  def revenues_per_type_per_month
    @revenues = Ticket.where(type_id: self.id).group("DATE_TRUNC('month', created_at)").count
    @parsed_revenues = {}
    price = self.price
    @revenues.each do |m|
      @parsed_revenues.reverse_merge!({"#{m[0].strftime("%b %Y")}": m[1] * price})
    end
    return @parsed_revenues
  end

  scope :history_price, -> (attendee_id) { joins(:tickets).where('tickets.attendee_id=?',attendee_id).pluck(:price)}
end