class UserProduction < ApplicationRecord
  belongs_to :user
  belongs_to :production

  validates :role, inclusion: { in: %w[admin volunteer] }
  validates :user_id, uniqueness: { scope: :production_id }
end
