class Bike < ApplicationRecord
  belongs_to :bike_request

  TYPES = %w[any male female kid].freeze
  enum :bike_type, { any: 0, male: 1, female: 2, kid: 3 }, default: :any

  after_update :sync_request_status, if: :saved_change_to_completed?

  private

  def sync_request_status
    req = bike_request
    if req.requested? && req.bikes.all?(&:completed?)
      req.update_columns(status: BikeRequest.statuses[:completed])
    elsif req.completed? && !req.bikes.all?(&:completed?)
      req.update_columns(status: BikeRequest.statuses[:requested])
    end
  end
end
