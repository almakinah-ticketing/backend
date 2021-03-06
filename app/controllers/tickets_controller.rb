class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :update, :destroy]

  # GET /tickets
  def index
    @tickets = Ticket.where(event_id: params[:event_id],type_id: params[:type_id])

    render json: @tickets.as_json(include: {type: {only: [:name, :price]}})
  end

  # GET /tickets/1
  def show
    render json: @ticket
  end
  # POST /tickets
  def create
    if current_attendee && params[:type_id] && params[:event_id]
       @ticket = Ticket.new(attendee_id: current_attendee.id, type_id: params[:type_id], event_id: params[:event_id])
      if @ticket.save
        render json: @ticket, status: :created
      else
        render json: @ticket.errors.full_messages, status: :unprocessable_entity
      end
    else
      render json: @ticket.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tickets/1
  def update
    if @ticket.update(ticket_params)
      render json: @ticket
    else
      render json: @ticket.errors.full_messages, status: :unprocessable_entity
    end
  end

  # DELETE /tickets/1
  def destroy
    @ticket.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ticket_params
      params.require(:ticket).permit(:attendee, :type, :event)
    end
end
