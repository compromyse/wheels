class Distribution < ApplicationRecord
  has_many :user_distributions, dependent: :destroy
  has_many :users, through: :user_distributions
  has_many :bike_requests, dependent: :destroy

  validates :name, presence: true
end
