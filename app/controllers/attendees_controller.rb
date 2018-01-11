class AttendeesController < ApplicationController
  before_action :set_attendee_hash, only: [:show]
  before_action :set_attendee, only: [:update, :destroy]
  before_action :authenticate_attendee!, only: [:index, :show, :update, :destroy]

  # GET /attendees
  def index
    @attendees = Attendee.all

    render json: @attendees, status: :ok
  end

  # GET /attendees/1
  def show
    render json: @attendee_hash, status: :ok, location: @attendee
  end

  # POST /attendees
  def create
    @attendee = Attendee.new(attendee_params)

    if @attendee.save
      # Invoke send email confirmation email method here - email includes attendee.confirmation_token
      render json: @attendee, status: :created, location: @attendee
    else
      render json: @attendee.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /attendees/1
  def update
    if @attendee.update(attendee_params)
      render json: @attendee, status: :ok, location: @attendee
    else
      render json: @attendee.errors, status: :unprocessable_entity
    end
  end

  # DELETE /attendees/1
  def destroy
    @attendee.destroy
    head :no_content
  end

  # POST /attendees/confirmations
  def confirm
    token = params[:token].to_s

    @attendee = Attendee.find_by(confirmation_token: token)

    if @attendee.present? && @attendee.confirmation_token_valid?
      @attendee.mark_as_confirmed!
      render json: @attendee, status: :ok, location: @attendee
    else
      render json: 'Invalid token', status: :not_found
    end
  end

  # POST /attendees/logins
  def login
    @attendee = Attendee.find_by(email: params[:email].to_s.downcase)

    if @attendee && @attendee.authenticate(params[:password])
      @attendee_ticket_objects = @attendee.tickets.to_a
      @attendee_ticket_hashes = []
      @attendee_ticket_objects.each do |ticket|
        @attendee_ticket_hashes << ticket.attributes
      end
      @attendee_hash = {
          attendee_id: @attendee.id,
          f_name: @attendee.f_name,
          l_name: @attendee.l_name,
          email: @attendee.email,
          tickets_bought: @attendee_ticket_hashes
        }
      # if @attendee.confirmed_at?
        auth_token = JsonWebToken.encode(@attendee_hash)
        render json: {auth_token: auth_token}, status: :ok
      # else
      #   render json: {error: 'Email Not Verified'}, status: :unauthorized
      # end
    else
      render json: 'Invalid username or password', status: :unauthorized
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendee
      @attendee = Attendee.find(params[:id])
    end

    def set_attendee_hash
      @attendee = Attendee.find(params[:id])

      @attendee_ticket_objects = @attendee.tickets.to_a
      @attendee_ticket_hashes = []
      @attendee_ticket_objects.each do |ticket|
        @attendee_ticket_hashes << ticket.attributes
      end

      @attendee_hash = {
          attendee_id: @attendee.id,
          f_name: @attendee.f_name,
          l_name: @attendee.l_name,
          email: @attendee.email,
          tickets_bought: @attendee_ticket_hashes
        }
    end

    # Only allow a trusted parameter "white list" through.
    def attendee_params
      params.require(:attendee).permit(:f_name, :l_name, :email, :phone_number, :password, :password_confirmation)
    end
end
