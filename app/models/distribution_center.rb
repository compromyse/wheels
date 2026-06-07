class DistributionCenter < ApplicationRecord
  has_many :user_distribution_centers, dependent: :destroy
  has_many :users, through: :user_distribution_centers

  validates :name, presence: true
end
