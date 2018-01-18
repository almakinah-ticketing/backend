class EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :destroy]

  # GET /events
  def index
      if params[:event_date] && params[:category_id]
        @events = Event.where(event_date: params[:event_date], category_id: params[:category_id]).order('start_datetime ASC')
      elsif params[:event_date]
        @events = Event.where(event_date: params[:event_date]).order('start_datetime ASC')
      elsif params[:category_id]
        @events = Event.where(category_id: params[:category_id]).order('start_datetime ASC')
      elsif params[:title]
        @events = Event.filter_by_title(params[:title].titlecase)
      elsif params[:popularity]
        if params[:popularity] == 'desc'
          @events = Event.all.sort_by(&:tickets_count).reverse
        elsif params[:popularity] == 'asc'
          @events = Event.all.sort_by(&:tickets_count)
        end
      else
        @events = Event.all.order('start_datetime ASC')
      end
      # typeTicketsavailable = @events.map(&:tickets_type)
      total_revenues_per_month = Event.revenues_per_month
      total_tickets_sold_per_month = Event.tickets_count_per_month
      display = []
      @events.each do |event|
        count = event.tickets_count
        count_per_month = event.tickets_count_per_month
        revenues_per_month = event.revenues_per_month
        available = event.tickets_available
        category = event.get_category
        hash = {
          tickets_available_per_event: available,
          tickets_sold: count,
          tickets_sold_per_month: count_per_month,
          revenues_per_month: revenues_per_month,
          total_revenues_per_month_for_all_events: total_revenues_per_month,
          total_tickets_sold_per_month_for_all_events: total_tickets_sold_per_month,
          data: event.as_json(include: {types: {only: [:name, :capacity, :price], methods: [:tickets_available_per_type, :tickets_sold_per_type, :tickets_sold_per_type_per_month, :revenues_per_type_per_month]}, category: {only: [:id, :name]}},
                                            except: [:category_id]
                                            )
        }
        display << hash
      end
      render json: display
  end

  # GET /events/1
  def show
    count = @event.tickets_count
    count_per_month = @event.tickets_count_per_month
    revenues_per_month = @event.revenues_per_month
    available = @event.tickets_available
    category = @event.get_category
    if current_attendee
      current_attendee_tickets = @event.tickets.where(attendee_id: current_attendee.id).count
    else 
      current_attendee_tickets = 0
    end
    display = {
      tickets_available_per_event: available,
      tickets_sold: count,
      tickets_sold_per_month: count_per_month,
      revenues_per_month: revenues_per_month,
      current_attendee_tickets: current_attendee_tickets,
      data:@event.as_json(include: {types: {only: [:id, :name, :capacity, :price], methods: [:tickets_available_per_type, :tickets_sold_per_type, :tickets_sold_per_type_per_month, :revenues_per_type_per_month]}, category: {only: [:id, :name]}},
                                          except: [:category_id]
                                          )
    }
    render json: display
  end

  
  # #events sorted according to hottest status
  # def hottest
  #   # render json: Event.order("RANDOM()").limit(1)
  #   @hottest_events = Event.hottest_events
  #   display = []
  #   @hottest_events.each do |event|
  #     count = event.tickets_count
  #     available = event.tickets_available
  #     category = event.get_category
  #     hash = {
  #       tickets_available_per_event: available,
  #       tickets_sold: count,
  #       data: event.as_json(include: {types: {only: [:name, :capacity], methods: :tickets_available_per_type}, category: {only: [:id, :name]}},
  #                                         except: [:category_id]
  #                                         )
  #     }
  #     display << hash
  #   end
  #   render json: display
  # end
    
  # POST /events
  def create
    @event = Event.new(event_params)
    @event.types_attributes = JSON.parse(params[:event][:types_attributes])
    @event.img = params[:file]
    count = @event.tickets_count
    count_per_month = @event.tickets_count_per_month
    revenues_per_month = @event.revenues_per_month
    available = @event.tickets_available
    category = @event.get_category
    if @event.save
      display = {
        tickets_available_per_event: available,
        tickets_sold: count,
        tickets_sold_per_month: count_per_month,
        revenues_per_month: revenues_per_month,
        data:@event.as_json(include: {types: {only: [:name, :capacity, :price], methods: [:tickets_available_per_type, :tickets_sold_per_type, :tickets_sold_per_type_per_month, :revenues_per_type_per_month]}, category: {only: [:id, :name]}},
                                            except: [:category_id]
                                            )
      }
      render json: display, status: :created, location: @event
    else
      render json: @event.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1
  def update
    cloned_params = event_params.clone
    if params[:event][:types_attributes]
      cloned_params[:types_attributes] = JSON.parse(params[:event][:types_attributes])
    end
    if @event.update(cloned_params)
      count = @event.tickets_count
      count_per_month = @event.tickets_count_per_month
      revenues_per_month = @event.revenues_per_month
      available = @event.tickets_available
      category = @event.get_category
      display = {
        tickets_available_per_event: available,
        tickets_sold: count,
        tickets_sold_per_month: count_per_month,
        revenues_per_month: revenues_per_month,
        data:@event.as_json(include: {types: {only: [:name, :capacity, :price], methods: [:tickets_available_per_type, :tickets_sold_per_type, :tickets_sold_per_type_per_month, :revenues_per_type_per_month]}, category: {only: [:id, :name]}},
                                            except: [:category_id]
                                            )
      }
      render json: display, status: :ok, location: @event
    else
      render json: @event.errors.full_messages, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    render body: nil, status: :no_content
  end

  def history
    if current_attendee
      @events = Event.history_titles(current_attendee.id).reverse
      @type = Type.history_price(current_attendee.id).reverse
      @ticket = Ticket.history_charge(current_attendee.id).reverse
      @type1 = Type.history_type(current_attendee.id).reverse
      @tickets = Ticket.history_id(current_attendee.id).reverse
      view = []
      size = @events.length
      i = 0
      while i< size do
        # view[i] = @events[i] + " for the price of " + @type[i].to_s + " EGP"
        view[i] = [event: @events[i] , price: @type[i] , charge: @ticket[i], type: @type1[i], id:@tickets[i]]
        i+=1
     end

      render json: view
    else
      render json: @events.errors.full_messages, status: :unprocessable_entity
    end
  end
  def calendar
    if current_attendee
     @events = Event.calender_titles(current_attendee.id)
     @events1 = Event.calender_sdate(current_attendee.id)
     @events2 = Event.calender_edate(current_attendee.id)
    view = []
    size = @events.length
      i = 0
      while i< size do
        view[i] = {title: @events[i] , start: @events1[i] , end: @events2[i]}
        i+=1
     end
    render json: view
  else
    render json: @events.errors, status: :unprocessable_entity
  end
  end


   private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def event_params
      params.require(:event).permit(:title, :overview, :agenda, :event_date, :start_datetime, :end_datetime, :category_id, :canceled, :img, :types_attributes)
    end
end


######### old aproach:
# def index
#   @event = Event.where(category_id: params[:category_id]).order('start_datetime ASC');
#     display = []
#     @event.each do |event| 
#       hash = event.as_json(
#         include: {types: {only: [:name, :capacity]}, category: {only: [:id, :name]}},
#         except: [:category_id]
#         )
#       display << hash;
#     end
#     render json: display
  
# end
#   #get all
#   def all
#     @events = Event.all
#     render json: @events.as_json(include: {category: {only: [:name]}, types: {only: [:name, :capacity]}})
#   endformData.append("event[title]", title);


# ##filter by date
#   def filters
#     @events = Event.where(event_date: params[:event_date])
#     render json: @events
#   end

#   ##filter by date & category
#   def double_filter
#     @events = Event.where(event_date: params[:event_date],category_id: params[:category_id])
#     render json: @events
#   end
##################################################################################################