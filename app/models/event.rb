class Event < ApplicationRecord
  mount_uploader :img, ImgUploader
  before_save :titlecase
  belongs_to :category
  has_many :types, dependent: :destroy
  has_many :tickets, dependent: :destroy

  accepts_nested_attributes_for :types

  validates :title, presence: true, uniqueness: true, length: {minimum: 1, maximum: 280}
  validates :overview, presence: true, length: {minimum: 1, maximum: 500}
  validates :agenda, presence: true, length: {minimum: 1, maximum: 5000}
  validates :event_date, presence: true
  validates :start_datetime, presence: true
  validates :end_datetime, presence: true

  after_initialize :set_event_date
  
#  #filter
#  def filter(date)
#   filteredEvents = Event.where(start_datetime: date)
#  end
  # sold tickets count

  def set_event_date
    self.event_date = self.start_datetime.to_date unless self.start_datetime.nil?
  end

  def tickets_count
    # scope :of_event, -> (id) { where(event_id: id) }
    # from_db = self.type.find(params[:id])
    type_ids = self.type_ids
    tickets = Ticket.where(type_id: type_ids).count
  end

  #remaining tickets
  def tickets_available
    type_ids = self.type_ids
    sold_tickets = Ticket.where(type_id: type_ids).count
    original_tickets = self.types.sum(:capacity)
    final_count = original_tickets - sold_tickets
  end

  # #events sorted according to hottest status
  # def self.hottest_events
  #   tickets_sold_array = Array.new
  #   Event.all.each do |event|
  #     type_ids = event.type_ids
  #     tickets_sold_array << Ticket.where(type_id: type_ids).count
  #   end
  #   tickets_sold_array_sorted.each do |tickets_sold|
  #     event_id = tickets_sold_array_sorted.index(tickets_sold) + 1
  #     event = Event.find(event_id)
  #     if event.tickets_available != 0
  #       return event
  #     else
  #   end
  #   return @hottest_events
  # end

  # # tickets available per type
  # def tickets_type
  #   sold_ticket =  Array.new
  #   # current_capacity = self.types.find('2').name
  #   types_array = self.types.pluck(:id)
  #   types_capacity = self.types.pluck(:capacity)
  #   j = 0
  #   while j < types_array.size 
  #     for i in types_array do
  #       sold_ticket[j] = Ticket.where(type_id: i).count
  #       j+=1
  #     end
  #   end
  #   k = 0
  #   available_ticket =  Array.new
  #   while k < types_array.size
  #     available_ticket[k] = types_capacity[k] - sold_ticket[k]
  #     k+=1;
  #   end
  #   return available_ticket
  # end

  # #tickets capacity per type
  # def capacity_type
  #   self.types.where(:capacity)
  # end

  #events category
  def get_category
    current_category = self.category.name
  end

  def get_available
    sold_ticket = Ticket.where(type_id: self.id).count
    current_capacity = self.capacity
    available_ticket = current_capacity - sold_ticket
    return available_ticket
  end

  def titlecase
    self.title = self.title.titlecase
  end
  

  # # Look into overriding default as_json implementation to return virtual attributes
  # def as_json(options = { })
  #   h = super(options)
  #   h[:finished]   = finished_items
  #   h[:unfinished] = unfinished_items
  #   h
  # end

  # def as_json(virtual_attributes, options={})
  #     super.as_json(options).merge({virtual_attributes})
  # end
end
