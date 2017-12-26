class EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :destroy]
  # GET /events
  def index
    @events = Event.order('event_date ASC');
    render json:@events
  end

  # GET /events/1
  def show
    count = @event.tickets_count
    available = @event.tickets_available
    category = @event.get_category
    typeTickets = @event.tickets_type
    display = {
      status: 'SUCCESS',
      category: category,
      tickets_available: available,
      tickets_sold: count,
      types_tickets: typeTickets,
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
