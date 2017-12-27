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
    typeTicketsavailable = @event.tickets_type
    display = {
      status: 'SUCCESS',
      category: category,
      tickets_available: available,
      tickets_sold: count,
      data:@event.as_json(include: {types: {only: [:name, :capacity]}}),
      tickets_available_per_type: typeTicketsavailable
    }
    render json: display
  end
  #hottest event
  def hot
    render json: 'hamada'
    
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
