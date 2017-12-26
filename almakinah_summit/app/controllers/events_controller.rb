class EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :destroy]
  # GET /events
  def index
    @events = Event.order('start_datetime ASC');
    display = []
    @events.each do |event| 
      hash = event.as_json(
        include: {types: {only: [:name, :capacity]}, category: {only: [:id, :name]}},
        except: [:category_id]
        )
      display << hash;
    end
    render json: display
  end

  # GET /events/1
  # Look into rendering this all as one object, perhaps using .to_json
  def show
    count = @event.tickets_count
    available = @event.tickets_available
    category = @event.get_category
    typeTickets = @event.tickets_type
    duration = @event.duration
    display = {
      status: 'SUCCESS',
      category: category,
      tickets_available: available,
      tickets_sold: count,
      types_tickets: typeTickets,
      duration: @event.duration,
      data:@event.as_json(include: {types: {only: [:name, :capacity]}})
    }
    render json: display
  end

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
      render json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
  end

   private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def event_params
      params.require(:event).permit(:title, :overview, :agenda, :event_date, :duration, :category_id)
    end
end
