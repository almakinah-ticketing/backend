class AdminMailer < ApplicationMailer

	 def admin_invitation(email, invitation_token)
    @token = invitation_token

    # mail from: 'info@facebook.com', to: email, subject: 'Welcome to AlMakinah'
    mail (to: email, subject: 'Welcome to AlMakinah')
   end
end
