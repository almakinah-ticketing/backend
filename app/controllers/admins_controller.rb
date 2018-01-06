class AdminsController < ApplicationController
  before_action :set_admin, only: [:show, :update, :destroy]
  before_action :authenticate_admin!, only: [:index, :show, :update, :destroy]

  attr_reader :current_admin

  # GET /admins
  def index
    @admins = Admin.all

    render json: @admins, status: :ok
  end

  # GET /admins/1
  def show
    render json: @admin, status: :ok, location: @admin
  end

  # POST /admins
  def create
    @admin = Admin.new(admin_params)

    if @admin.save
      # Invoke send email confirmation email method here - email includes admin.confirmation_token
      render json: @admin, status: :created, location: @admin
    else
      render json: @admin.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admins/1
  def update
    if @admin.update(admin_params)
      render json: @admin, status: :ok, location: @attendee
    else
      render json: @admin.errors, status: :unprocessable_entity
    end
  end

  # DELETE /admins/1
  def destroy
    @admin.destroy
    head :no_content
  end

  # POST /admins/confirm
  def confirm
    token = params[:token].to_s

    @admin = Admin.find_by(confirmation_token: token)

    if @admin.present? && @admin.confirmation_token_valid?
      @admin.mark_as_confirmed!
      render json: @admin, status: :ok, location: @admin
    else
      render json: 'Invalid token', status: :not_found
    end
  end

  # POST /admins/login
  def login
    @admin = Admin.find_by(email: params[:email].to_s.downcase)

    if @admin && @admin.authenticate(params[:password])
      # if @admin.confirmed_at?
        # admin_hash = @admin.attributes
        admin_hash = {
          admin_id: @admin.id,
          f_name: @admin.f_name,
          l_name: @admin.l_name,
          email: @admin.email
        }
        auth_token = JsonWebToken.encode(admin_hash)
        render json: {auth_token: auth_token}, status: :ok
      # else
      #   render json: {error: 'Email Not Verified'}, status: :unauthorized
      # end
    else
      render json: 'Invalid username or password', status: :unauthorized
    end
  end

  protected
  def authenticate_admin!
    if !payload || !JsonWebToken.valid_payload(payload) || !admin_id_in_token?
      return invalid_authentication
    end

    @current_admin = Admin.find(payload[:admin_id])
  rescue JWT::VerificationError, JWT::DecodeError
    return invalid_authentication    
  end

  def invalid_authentication
    render json: 'Not authenticated', status: :unauthorized
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def admin_params
      params.require(:admin).permit(:f_name, :l_name, :email, :phone_number, :password, :password_confirmation)
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

    def admin_id_in_token?
      token && payload && payload[:admin_id].to_i
    end
end
