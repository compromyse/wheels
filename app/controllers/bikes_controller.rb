class BikesController < ApplicationController
  before_action :set_bike
  before_action :check_access

  def update
    @bike.update!(completed: !@bike.completed)
    req = @bike.bike_request.reload
    redirect_to tickets_production_path(req.production, tab: req.status)
  end

  private

  def set_bike
    @bike = Bike.find(params[:id])
  end

  def check_access
    require_production_access(@bike.bike_request.production)
  end
end
