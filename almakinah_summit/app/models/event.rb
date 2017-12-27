class Event < ApplicationRecord
  belongs_to :category
  validates :title, presence: true
  validates :overview, presence: true
  validates :start_datetime, presence: true
  validates :end_datetime, presence: true
  has_many :types, dependent: :destroy
  has_many :tickets, dependent: :destroy

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

  # tickets per type
  def tickets_type
    # self.types.where(:capacity)
    current_capacity = self.types.find('2').name
    types_array = self.types.ids
  end

  #events category
  def get_category
    current_category = self.category.name
  end

  # calculate duration based on start and end datetimes
  def duration
    self.end_datetime - self.start_datetime    
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
