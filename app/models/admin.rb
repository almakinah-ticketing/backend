require 'digest/sha2'
class Admin < ApplicationRecord
  # include Validatable
  include Confirmable

  has_many :events, dependent: :destroy
  has_many :admin_activities

  before_save :downcase_email

  has_secure_password validations: !:skip_validations

  validates :email, presence: true, uniqueness: true, case_sensitive: false
  validates_email_format_of :email, :message => 'Invalid email format. Valid format is email@example.com.'
  validates :f_name, presence: true, length: {minimum: 1, maximum: 20}, format: {with: /[A-Z]+\w*/}, unless: :skip_validations
  validates :l_name, presence: true, length: {minimum: 1, maximum: 20}, format: {with: /[A-Z]+\w*/}, unless: :skip_validations
  validates :phone_number, presence: true, length: {minimum: 9, maximum: 11}, format: {with: /\d*/}, unless: :skip_validations
  # validates :password, presence: true, confirmation: true, length: {minimum: 8, maximum: 72}, format: {with: /(\w*[-\/\\^$*+?!&.()|[\]{}]*){3,10}/}
 

 def downcase_email
    self.email = self.email.delete(' ').downcase
 end

  def skip_validations
    self.invitation_token.present?
  end

  def invite!(message)
	    payload = "#{Time.now.to_i}.#{Random.new.rand(1000)}.#{Rails.application.secrets.secret_key_base}"
	    self.invitation_token = Digest::SHA2.hexdigest(payload)
	    self.invited_at = DateTime.now
	    if self.save
	      AdminMailer.admin_invitation(self.email, self.invitation_token, message).deliver_now
	    end
  end

  def accept_invitation!(params)
    params[:invitation_token] = nil
    self.update params
  end
end
