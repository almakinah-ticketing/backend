class UpdatesEmailsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    UpdatesMailer.updates_mail(self.attendee_email, update).deliver_later
  end
end
