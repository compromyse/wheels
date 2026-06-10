class UserProduction < ApplicationRecord
  belongs_to :user
  belongs_to :production

  ROLES = %w[admin volunteer].freeze

  validates :role, inclusion: { in: ROLES }
  validates :user_id, uniqueness: { scope: :production_id }
end
