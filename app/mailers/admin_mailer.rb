class AdminMailer < ApplicationMailer

	 def admin_invitation(email, invitation_token, message)
    @token = invitation_token
    @message = message

    mail from: 'lara.aasem@aucegypt.edu', to: email, subject: 'Welcome to AlMakinah'
  end

end
