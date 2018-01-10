class Admin < ApplicationRecord
  include Validatable
  include Confirmable

  has_many :events, dependent: :destroy
  has_many :admin_activities

    def invite!
	    payload = "#{Time.now.to_i}.#{Random.new.rand(1000)}.#{Rails.application.secrets.secret_key_base}"
	    self.invitation_token = Digest::SHA2.hexdigest(payload)
	    self.invited_at = DateTime.now
	    if self.save
	      InvitationsMailer.admin_invitation(self.email, self.invitation_token).deliver_now
	    end
  end

  def accept_invitation!(params)
    params[:invitation_token] = nil
    self.update params
  end
end
