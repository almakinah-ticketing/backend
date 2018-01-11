class AdminActivity < ApplicationRecord
  belongs_to :admin
  belongs_to :event

  validates :action, presence: true, format: {with: /[a-z]*/}
end
