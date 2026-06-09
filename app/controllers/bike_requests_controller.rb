class BikeRequestsController < ApplicationController
  before_action :set_distribution_center, only: [ :new, :create ]
  before_action :check_dc_access, only: [ :new, :create ]
  before_action :set_bike_request, only: [ :update ]
  before_action :check_factory_access, only: [ :update ]

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

  def update
    case params[:status]
    when "pending"
      @bike_request.update!(status: :pending, assignee: current_user)
    when "completed"
      @bike_request.update!(status: :completed)
    when "requested"
      @bike_request.update!(status: :requested, assignee: nil)
    end

    redirect_to factory_path(@bike_request.factory, tab: @bike_request.status)
  end

  private

  def set_distribution_center
    @distribution_center = DistributionCenter.find(params[:distribution_center_id])
  end

  def check_dc_access
    require_distribution_center_access(@distribution_center)
  end

  def set_bike_request
    @bike_request = BikeRequest.find(params[:id])
  end

  def check_factory_access
    require_factory_access(@bike_request.factory)
  end

  def bike_request_params
    params.require(:bike_request).permit(:phone, :requestor_name, :due_date, :recipient_name, :bike_type, :age, :height, :notes)
  end
end
