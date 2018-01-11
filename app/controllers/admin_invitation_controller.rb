class AdminInvitationController < ApplicationController
	 # before_action :authenticate_request!

	def invitation

	   @admin = Admin.new  admin_params
	   p params[:admin][:message]
	   message = params[:admin][:message]

	    if @admin.invite! message
	      render json: @admin, status: :created
	    else
	      render json: @admin.errors.full_messages, status: :unprocessable_entity
	    end
 	end



   private
  def admin_params
    params.require(:admin).permit(:email)
  end

end



