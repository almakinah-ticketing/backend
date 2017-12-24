class Admin < ApplicationRecord
    validates :email, presence: true, uniqueness: true
    validates_email_format_of :email, :message => 'wrong email format it should be email@example.com'
    validates :f_name, presence: true
    validates :l_name, presence: true
    validates :phone_number, presence: true
    validates :password, presence: true
    has_many :events, dependent: :destroy
end
