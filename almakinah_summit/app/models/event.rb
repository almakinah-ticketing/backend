class Event < ApplicationRecord
  belongs_to :category
  validates :title, presence: true
  validates :overview, presence: true
  validates :event_date, presence: true
  validates :start_datetime, presence: true
  validates :end_datetime, presence: true
  has_many :types, dependent: :destroy
  has_many :tickets, dependent: :destroy

  scope :starts_with, -> (start_datetime) { where("start_datetime like ?", "#{date}%")}



  # sold tickets count
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

  #hottest event
  def hottest_event
    
    
  end

  # tickets available per type
  def tickets_type
    sold_ticket =  Array.new
    # current_capacity = self.types.find('2').name
    types_array = self.types.pluck(:id)
    types_capacity = self.types.pluck(:capacity)
    j = 0
    while j < types_array.size 
      for i in types_array do
        sold_ticket[j] = Ticket.where(type_id: i).count
        j+=1
      end
    end
    k = 0
    available_ticket =  Array.new
    while k < types_array.size
      available_ticket[k] = types_capacity[k] - sold_ticket[k]
      k+=1;
    end
    return available_ticket
  end

  # #tickets capacity per type
  # def capacity_type
  #   self.types.where(:capacity)
  # end

  #events category
  def get_category
    current_category = self.category.name
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
