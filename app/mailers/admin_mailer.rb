class AdminMailer < ApplicationMailer

	 def admin_invitation(email, invitation_token, message)
    @token = invitation_token
    @message = message

    mail from: 'info@facebook.com', to: email, subject: 'Welcome to AlMakinah'
  end

end
