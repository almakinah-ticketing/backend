class ChargesController < ApplicationController

  def new
    @event_id = params[:event_id]
  end

  def create
    
    stripeToken = params[:stripeToken]
    amount = (params[:amount] * 100).to_i
      charge = Stripe::Charge.create(
        :source  => stripeToken,
        :amount      => amount,
        :description => 'Almakinah Ticket customer',
        :currency    => 'EGP'
      )
  end
end
