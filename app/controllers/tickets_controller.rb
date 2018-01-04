class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :update, :destroy]

  # GET /tickets
  def index
    @tickets = Ticket.where(event_id: params[:event_id],type_id: params[:type_id])

    render json: @tickets
  end

  # GET /tickets/1
  def show
    render json: @ticket
  end
  #payment
  def payment
    respond_to do |format|
      format.html { redirect_to controller: 'charges', action: 'new', event_id: @event_id}
    end
  end
  # POST /tickets
  def create
    if params[:attendee_id] && params[:type_id] && params[:event_id]
       @ticket = Ticket.new(attendee_id: params[:attendee_id], type_id: params[:type_id], event_id: params[:event_id])
      if @ticket.save
        render json: @ticket, status: :created
      else
        render json: @ticket.errors, status: :unprocessable_entity
      end
    else
      render json: @ticket.errors, status: :unprocessable_entity
    end
  end
  #attendee_id: params[:attendee_id], type_id: params[:type_id], event_id: params[:event_id]

  # PATCH/PUT /tickets/1
  def update
    if @ticket.update(ticket_params)
      render json: @ticket
    else
      render json: @ticket.errors, status: :unprocessable_entity
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
