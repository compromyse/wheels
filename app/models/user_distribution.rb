class UserDistribution < ApplicationRecord
  belongs_to :user
  belongs_to :distribution

  validates :role, inclusion: { in: %w[admin volunteer] }
  validates :user_id, uniqueness: { scope: :distribution_id }
end
