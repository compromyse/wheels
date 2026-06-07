class UserFactory < ApplicationRecord
  belongs_to :user
  belongs_to :factory

  validates :role, inclusion: { in: %w[admin volunteer] }
end
