class InvitedAdminRegistrationController < ApplicationController
 def show
    @admin = Admin.find_by invitation_token: params[:invitation_token]

    if @admin
      render json: @admin, status: :ok
    else
      render json: {message: 'Invalid invitation token'}, status: :not_found
    end
 end

  def update
    @admin = Admin.find params[:admin_id]

    if @admin.accept_invitation!(admin_params)
      render json: @admin, status: :ok
    else
      render json: @admin.errors.full_messages, status: :unprocessable_entity
    end
  end

  def admin_params
    params.require(:admin).permit(:f_name, :l_name, :email, :phone_number, :password, :password_confirmation, :invitation_token)
  end
end
