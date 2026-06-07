class BikeRequestsController < ApplicationController
  before_action :set_distribution_center
  before_action :check_access

  def new
    @bike_request = BikeRequest.new(due_date: Date.today + 14)
    @factory = Factory.first
  end

  def create
    @factory = Factory.first
    @bike_request = BikeRequest.new(bike_request_params)
    @bike_request.distribution_center = @distribution_center
    @bike_request.factory = @factory
    @bike_request.user = current_user

    if @bike_request.save
      redirect_to distribution_center_path(@distribution_center), notice: "Bike request submitted."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_distribution_center
    @distribution_center = DistributionCenter.find(params[:distribution_center_id])
  end

  def check_access
    require_distribution_center_access(@distribution_center)
  end

  def bike_request_params
    params.require(:bike_request).permit(:phone, :requestor_name, :due_date, :recipient_name, :bike_type, :age, :height, :notes)
  end
end
