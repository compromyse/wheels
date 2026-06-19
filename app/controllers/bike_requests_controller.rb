class BikeRequestsController < ApplicationController
  before_action :set_distribution, only: [ :new, :create ]
  before_action :check_distribution_access, only: [ :new, :create ]
  before_action :set_bike_request, only: [ :update ]
  before_action :check_production_access, only: [ :update ]

  def new
    @bike_request = BikeRequest.new(due_date: Date.today + 14)
    @bike_request.bikes.build
    @production = Production.first
  end

  def create
    @production = Production.first
    @bike_request = BikeRequest.new(bike_request_params)
    @bike_request.distribution = @distribution
    @bike_request.production = @production
    @bike_request.user = current_user

    if @bike_request.save
      redirect_to tickets_distribution_path(@distribution), notice: "Bike request submitted."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    attributes = case params[:status]
    when "completed"    then { status: :completed }
    when "delivered"    then { status: :delivered }
    when "distributed"  then { status: :distributed }
    end

    original_status = @bike_request.status

    if attributes && @bike_request.update(attributes)
      redirect_to tickets_production_path(@bike_request.production, tab: @bike_request.status)
    else
      redirect_to tickets_production_path(@bike_request.production, tab: original_status),
        alert: @bike_request.errors.full_messages.first
    end
  end

  private

  def set_distribution
    @distribution = Distribution.find(params[:distribution_id])
  end

  def check_distribution_access
    require_distribution_access(@distribution)
  end

  def set_bike_request
    @bike_request = BikeRequest.find(params[:id])
  end

  def check_production_access
    require_production_access(@bike_request.production)
  end

  def bike_request_params
    params.require(:bike_request).permit(
      :phone, :requestor_name, :due_date,
      bikes_attributes: [ :name, :bike_type, :age, :height, :notes ]
    )
  end
end
