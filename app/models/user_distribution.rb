class UserDistribution < ApplicationRecord
  belongs_to :user
  belongs_to :distribution

  ROLES = %w[admin volunteer].freeze

  validates :role, inclusion: { in: ROLES }
  validates :user_id, uniqueness: { scope: :distribution_id }
end
