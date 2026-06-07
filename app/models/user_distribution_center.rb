class UserDistributionCenter < ApplicationRecord
  belongs_to :user
  belongs_to :distribution_center

  validates :role, inclusion: { in: %w[admin volunteer] }
end
