class ChargesController < ApplicationController

  def new
  end
  def create
    stripeToken = params[:stripeToken]
    amount = (params[:amount] * 100).to_i
    attendee_id = params[:attendee_id]
    type_id = params[:type_id]
    type_ids = params[:type_ids]
    event_id = params[:event_id]
    charge = Stripe::Charge.create(
      :source  => stripeToken,
      :amount      => amount,
      :description => 'Almakinah Ticket customer',
      :currency    => 'EGP'
      )
      ch = charge.id
    if charge.status == 'succeeded'
      type_ids.each do |type|
        ticket = Ticket.new(attendee_id: attendee_id, type_id: type, event_id: event_id, charge: ch)
        ticket.save
      end
    end
  end

  def refund
    ch_token = params[:charge]
    re = Stripe::Refund.create(
        charge: ch_token
        )
  end
end
