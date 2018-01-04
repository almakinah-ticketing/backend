class ChargesController < ApplicationController

  def new
    @event_id = params[:event_id]
  end

  def create
    # Amount in cents
    @amount = 500
    charge_error = nil

    begin
      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken]
      )
      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @amount,
        :description => 'Rails Stripe customer',
        :currency    => 'usd'
      )
    rescue Stripe::CardError => e
      charge_error = e.message
    end

    if charge_error
      flash[:error] = charge_error
      render :new
    else
      @event = Event.find(params[:event_id])
      ticket = Ticket.new(ticket_params)
      ticket.save
    end
  end

  private
  def ticket_params
    params.require(:ticket).permit(:attendee, :type, :event)
  end
end
