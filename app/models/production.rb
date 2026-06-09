class Production < ApplicationRecord
  has_many :user_productions, dependent: :destroy
  has_many :users, through: :user_productions
  has_many :bike_requests, dependent: :destroy

  validates :name, presence: true
end
