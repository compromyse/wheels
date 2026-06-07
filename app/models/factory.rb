class Factory < ApplicationRecord
  has_many :user_factories, dependent: :destroy
  has_many :users, through: :user_factories

  validates :name, presence: true
end
