class Factory < ApplicationRecord
  has_many :user_factories, dependent: :destroy
  has_many :users, through: :user_factories
  has_many :bike_requests, dependent: :destroy

  validates :name, presence: true
end
