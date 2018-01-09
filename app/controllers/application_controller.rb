class ApplicationController < ActionController::API
  require 'json_web_token'

  attr_accessor :current_attendee, :current_admin

  def authenticate_attendee!
    if  !current_attendee.present?
      return invalid_authentication
    end
  rescue JWT::VerificationError, JWT::DecodeError
    return invalid_authentication    
  end

  def authenticate_admin!
    if  !current_admin.present?
      return invalid_authentication
    end
  rescue JWT::VerificationError, JWT::DecodeError, JWT::ExpiredSignature
    return invalid_authentication    
  end

  def invalid_authentication
    render json: 'Not authenticated', status: :unauthorized
  end

  private
  def token
    @token ||= request.headers['Authorization']
  end

  def payload
    @payload ||= JsonWebToken.decode(token)
  end

  def current_attendee
    @current_attendee ||= Attendee.find(payload[:attendee_id])
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def current_admin
    @current_admin ||= Admin.find(payload[:admin_id])
  rescue ActiveRecord::RecordNotFound
    nil
  end
end

