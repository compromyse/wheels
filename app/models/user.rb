class User < ApplicationRecord
  has_secure_password

  has_many :user_productions, dependent: :destroy
  has_many :productions, through: :user_productions
  has_many :user_distributions, dependent: :destroy
  has_many :distributions, through: :user_distributions

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  def all_locations
    productions.to_a + distributions.to_a
  end

  def single_location?
    all_locations.size == 1
  end
end
