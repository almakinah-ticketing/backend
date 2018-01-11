class Attendee < ApplicationRecord
  # include Validatable
  include Confirmable

  has_many :tickets, dependent: :destroy

  before_save :downcase_email

  has_secure_password 
  # validations: !:skip_validations

  validates :email, presence: true, uniqueness: true, case_sensitive: false
  validates_email_format_of :email, :message => 'Invalid email format. Valid format is email@example.com.'
  validates :f_name, presence: true, length: {minimum: 1, maximum: 20}, format: {with: /[A-Z]+\w*/}
  # , unless: :skip_validations
  validates :l_name, presence: true, length: {minimum: 1, maximum: 20}, format: {with: /[A-Z]+\w*/}
  # , unless: :skip_validations
  validates :phone_number, presence: true, length: {minimum: 9, maximum: 11}, format: {with: /\d*/}
  # , unless: :skip_validations
  # validates :password, presence: true, confirmation: true, length: {minimum: 8, maximum: 72}, format: {with: /(\w*[-\/\\^$*+?!&.()|[\]{}]*){3,10}/}
 

 def downcase_email
    self.email = self.email.delete(' ').downcase
  end

end
