class BikeRequest < ApplicationRecord
  belongs_to :distribution_center
  belongs_to :factory
  belongs_to :user
  belongs_to :assignee, class_name: "User", optional: true

  enum :bike_type, { male: 0, female: 1, kid: 2 }
  enum :status, { requested: 0, pending: 1, completed: 2 }

  validates :phone, presence: true
  validates :bike_type, presence: true
  validates :requestor_name, presence: true
  validates :due_date, presence: true
  validate :due_date_in_future, on: :create

  private

  def due_date_in_future
    return unless due_date
    errors.add(:due_date, "must be in the future") if due_date <= Date.today
  end
end
