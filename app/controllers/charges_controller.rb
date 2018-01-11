class ChargesController < ApplicationController

  def new
    @event_id = params[:event_id]
  end

  def create
    
    # x =params[:charge][:stripeToken].replace('tok', 'ch')
    stripeToken = params[:stripeToken]
    amount = (params[:amount] * 100).to_i
      charge = Stripe::Charge.create(
        :source  => stripeToken,
        :amount      => amount,
        :description => 'Almakinah Ticket customer',
        :currency    => 'EGP'
      )
    # if charge.status == 'success'
    #   charge.id
    # end
  end
end
