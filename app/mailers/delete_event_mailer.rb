class DeleteEventMailer < ApplicationMailer
    def delete_mail (attendee_email, event)
        @event = event
        mail from: 'lara.aasem@aucegypt.edu',to: attendee_email, subject: 'Updates'
    end
end
