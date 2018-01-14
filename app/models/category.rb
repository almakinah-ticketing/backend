class Category < ApplicationRecord
    has_many :events
    
    validates :name, presence: true, uniqueness: true, length: {minimum: 1, maximum: 20}, format: {with: /[A-Z]+\w*/}
end
