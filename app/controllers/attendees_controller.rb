class AttendeesController < ApplicationController
  before_action :set_attendee, only: [:show, :update, :destroy]
  before_action :authenticate_attendee!, only: [:index, :show, :update, :destroy]

  attr_reader :current_attendee

  # GET /attendees
  def index
    @attendees = Attendee.all

    render json: @attendees, status: :ok
  end

  # GET /attendees/1
  def show
    render json: @attendee, status: :ok, location: @attendee
  end

  # POST /attendees
  def create
    @attendee = Attendee.new(attendee_params)

    if @attendee.save
      # Invoke send email confirmation email method here - email includes admin.confirmation_token
      render json: @attendee, status: :created, location: @attendee
    else
      render json: @attendee.errors, status: :unprocessable_entity
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

  # POST /attendees/confirm
  def confirm
    token = params[:token].to_s

    @attendee = Attendee.find_by(confirmation_token: token)

    if @attendee.present? && @attendee.confirmation_token_valid?
      @attendee.mark_as_confirmed!
      render json: @attendee, status: :ok, location: @attendee
    else
      render json: {error: 'Invalid Token'}, status: :not_found
    end
  end

  # POST /attendees/login
  def login
    @attendee = Attendee.find_by(email: params[:email].to_s.downcase)

    if @attendee && @attendee.authenticate(params[:password])
      if @attendee.confirmed_at?
        auth_token = JsonWebToken.encode({attendee_id: @attendee.id})
        render json: {auth_token: auth_token}, status: :ok
      else
        render json: {error: 'Email Not Verified'}, status: :unauthorized
      end
    else
      render json: {error: 'Invalid Username/Password'}, status: :unauthorized
    end
  end

  protected
  def authenticate_attendee!
    if !payload || !JsonWebToken.valid_payload(payload) || !attendee_id_in_token?
      return invalid_authentication
    end

    @current_attendee = Attendee.find(payload[:attendee_id])
  rescue JWT::VerificationError, JWT::DecodeError
    return invalid_authentication    
  end

  def invalid_authentication
    render json: {error: 'Not Authenticated'}, status: :unauthorized
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendee
      @attendee = Attendee.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def attendee_params
      params.require(:attendee).permit(:f_name, :l_name, :email, :phone_number, :password, :password_confirmation)
    end

    def token
      @token ||= if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      end
    end

    def payload
      @payload ||= JsonWebToken.decode(token)
    rescue
      nil
    end

    def attendee_id_in_token?
      token && payload && payload[:attendee_id].to_i
    end
end
