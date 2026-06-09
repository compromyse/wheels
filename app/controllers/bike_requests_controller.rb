class BikeRequestsController < ApplicationController
  before_action :set_distribution, only: [ :new, :create ]
  before_action :check_distribution_access, only: [ :new, :create ]
  before_action :set_bike_request, only: [ :update ]
  before_action :check_production_access, only: [ :update ]

  def new
    @bike_request = BikeRequest.new(due_date: Date.today + 14)
    @production = Production.first
  end

  def create
    @production = Production.first
    @bike_request = BikeRequest.new(bike_request_params)
    @bike_request.distribution = @distribution
    @bike_request.production = @production
    @bike_request.user = current_user

    if @bike_request.save
      redirect_to distribution_path(@distribution), notice: "Bike request submitted."
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
    when "delivered"
      @bike_request.update!(status: :delivered)
    when "distributed"
      @bike_request.update!(status: :distributed)
    when "requested"
      @bike_request.update!(status: :requested, assignee: nil)
    end

    redirect_to production_path(@bike_request.production, tab: @bike_request.status)
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
    params.require(:bike_request).permit(:phone, :requestor_name, :due_date, :recipient_name, :bike_type, :age, :height, :notes)
  end
end
