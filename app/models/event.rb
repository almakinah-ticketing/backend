class Event < ApplicationRecord
  mount_uploader :img, ImgUploader
  before_save :titlecase
  belongs_to :category
  has_many :types, dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :admin_activities
  has_many :attendees, through: :tickets

  accepts_nested_attributes_for :types, allow_destroy: true

  accepts_nested_attributes_for :types

  validates :title, presence: true, uniqueness: true, length: {minimum: 1, maximum: 280}
  validates :overview, presence: true, length: {minimum: 1, maximum: 500}
  validates :agenda, presence: true, length: {minimum: 1, maximum: 5000}
  validates :event_date, presence: true
  validates :start_datetime, presence: true
  validates :end_datetime, presence: true

  after_initialize :set_event_date
  after_update :send_emails

  scope :history_titles, -> (attendee_id) { joins(:tickets).where('tickets.attendee_id = ?', attendee_id).pluck(:title) }
  scope :calender_titles, -> (attendee_id) { joins(:tickets).where('tickets.attendee_id = ?', attendee_id).distinct.pluck(:title) }  
  scope :calender_sdate, -> (attendee_id) {joins(:tickets).where('tickets.attendee_id = ?', attendee_id).pluck(:start_datetime)}
  scope :calender_edate, -> (attendee_id) {joins(:tickets).where('tickets.attendee_id = ?', attendee_id).pluck(:end_datetime)}
  # scope :calender_title, -> (attendee_id) {joins(:tickets).where('tickets.attendee_id = ?', attendee_id).pluck(:title,:start_datetime,:end_datetime)}
  scope :filter_by_title, -> (title) { where('title LIKE ?', "%#{title}%") }

#  #filter
#  def filter(date)
#   filteredEvents = Event.where(start_datetime: date)
#  end
  # sold tickets count

  def send_emails
    self.attendees.each do |attendee|
      UpdatesMailer.updates_mail(attendee.email, self).deliver_now
    end
  end

  def set_event_date
    self.event_date = self.start_datetime.to_date unless self.start_datetime.nil?
  end

  def tickets_count
    # scope :of_event, -> (id) { where(event_id: id) }
    # from_db = self.type.find(params[:id])
    # byebug
    # type_ids = self.type_ids
    Ticket.where(event_id: self.id).count
  end

  # TODO: OPTIMIZE
  def tickets_count_per_month
    # .group() returns [{<datetime>: <count_value>}]
    @counts = Ticket.where(event_id: self.id).group("DATE_TRUNC('month', created_at)").count
    @parsed_counts = {}
    # looping over array returned by .group() to change key format from <datetime> to <month> <year>, eg. "Jan 2018"
    @counts.each do |m|
      @parsed_counts.reverse_merge!({"#{m[0].strftime("%b %Y")}": m[1]})
    end
    @parsed_counts
  end

  # TODO: OPTIMIZE
  def self.tickets_count_per_month
    events = Event.all
    # TODO: Find better way to get max and all keys instead of hardcoding them
    keys = ["Jan 2018", "Feb 2018", "Mar 2018", "Apr 2018", "May 2018", "Jun 2018", "Jul 2018", "Aug 2018", "Sep 2018", "Oct 2018", "Nov 2018", "Dec 2018"]
    keys = events[0].revenues_per_month.keys
    # # old way of getting keys instead of hardcoding them but only gets keys from event with most keys --> might not necessarily be a combination of all months
    # for event in events
    #   if event.revenues_per_month.keys.length > keys.length
    #     keys = event.revenues_per_month.keys
    #   end
    # end
    total_tickets_count_per_month = {}
    # looping over keys to turn each key to a symbol and initialize count per month for that key to 0
    for key in keys
      key = key.to_sym
      total_tickets_count_per_month[key] = 0
      # looping over events to add ticket count for each event, if it exists, to total counts
      for event in events
        if event.tickets_count_per_month[key]
          total_tickets_count_per_month[key] += event.tickets_count_per_month[key]
        end
      end
    end
    total_tickets_count_per_month
  end

  # TODO: OPTIMIZE
  def revenues_per_month
    types = self.types
    # TODO: Find better way to get max and all keys instead of hardcoding them
    keys = ["Jan 2018", "Feb 2018", "Mar 2018", "Apr 2018", "May 2018", "Jun 2018", "Jul 2018", "Aug 2018", "Sep 2018", "Oct 2018", "Nov 2018", "Dec 2018"]
    # keys = types[0].revenues_per_type_per_month.keys
    # for type in types
    #   if type.revenues_per_type_per_month.keys.length > keys.length
    #     keys = type.revenues_per_type_per_month.keys
    #   end
    # end
    revenues_per_month = {}
    for key in keys 
        key = key.to_sym
        revenues_per_month[key] = 0
        for type in types
          if type.revenues_per_type_per_month[key]
            revenues_per_month[key] += type.revenues_per_type_per_month[key]
          else
            revenues_per_month[key] = 0
          end
        end
      end
      revenues_per_month
  end

  # TODO: OPTIMIZE
  def self.revenues_per_month
    events = Event.all
    # TODO: Find better way to get max and all keys instead of hardcoding them
    keys = ["Jan 2018", "Feb 2018", "Mar 2018", "Apr 2018", "May 2018", "Jun 2018", "Jul 2018", "Aug 2018", "Sep 2018", "Oct 2018", "Nov 2018", "Dec 2018"]
    # keys = events[0].revenues_per_month.keys
    #  for event in events
    #   if event.revenues_per_month.keys.length > keys.length
    #     keys = event.revenues_per_month.keys
    #   end
    # end
    total_revenues_per_month = {}
    for key in keys
      key = key.to_sym
      total_revenues_per_month[key] = 0
      for event in events
        if event.revenues_per_month[key]
          total_revenues_per_month[key] += event.revenues_per_month[key]
        else
          total_revenues_per_month[key] += 0
        end
      end
    end
    total_revenues_per_month
  end

  #remaining tickets
  def tickets_available
    type_ids = self.type_ids
    sold_tickets = Ticket.where(event_id: self.id).count
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