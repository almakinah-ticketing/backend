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
      else
        @events = Event.all.order('start_datetime ASC')
      end
      # typeTicketsavailable = @events.map(&:tickets_type)
      display = []
      @events.each do |event|
        count = event.tickets_count
        available = event.tickets_available
        category = event.get_category
        hash = {
          tickets_available_per_event: available,
          tickets_sold: count,
          data: event.as_json(include: {types: {only: [:name, :capacity], methods: :tickets_available_per_type}, category: {only: [:id, :name]}},
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
    available = @event.tickets_available
    category = @event.get_category
    display = {
      tickets_available_per_event: available,
      tickets_sold: count,
      data:@event.as_json(include: {types: {only: [:name, :capacity, :price], methods: :tickets_available_per_type}, category: {only: [:id, :name]}},
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

    if @event.save
      render json: @event, status: :created, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      render json: @event, status: :ok, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    render body: nil, status: :no_content
  end

   private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def event_params
      params.require(:event).permit(:title, :overview, :agenda, :event_date, :start_datetime, :end_datetime, :duration, :category_id)
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
#   end


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