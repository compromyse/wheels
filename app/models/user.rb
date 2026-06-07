class User < ApplicationRecord
  has_secure_password

  has_many :user_factories, dependent: :destroy
  has_many :factories, through: :user_factories
  has_many :user_distribution_centers, dependent: :destroy
  has_many :distribution_centers, through: :user_distribution_centers

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  def all_locations
    factories.to_a + distribution_centers.to_a
  end

  def single_location?
    all_locations.size == 1
  end
end
