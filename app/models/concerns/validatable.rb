module Validatable
  extend ActiveSupport::Concern

 included do
  before_save :downcase_email

  has_secure_password

  validates :email, presence: true, uniqueness: true, case_sensitive: false
  validates_email_format_of :email, :message => 'Invalid email format. Valid format is email@example.com.'
  validates :f_name, presence: true, length: {minimum: 1, maximum: 20}, format: {with: /[A-Z]+\w*/}
  validates :l_name, presence: true, length: {minimum: 1, maximum: 20}, format: {with: /[A-Z]+\w*/}
  validates :phone_number, presence: true, length: {minimum: 9, maximum: 11}, format: {with: /\d*/}
  # validates :password, presence: true, confirmation: true, length: {minimum: 8, maximum: 72}, format: {with: /(\w*[-\/\\^$*+?!&.()|[\]{}]*){3,10}/}
 end

 def downcase_email
    self.email = self.email.delete(' ').downcase
  end
end