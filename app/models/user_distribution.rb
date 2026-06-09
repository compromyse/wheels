class UserDistribution < ApplicationRecord
  belongs_to :user
  belongs_to :distribution

  validates :role, inclusion: { in: %w[admin volunteer] }
end
