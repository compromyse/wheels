class FactoriesController < ApplicationController
  before_action :set_factory
  before_action :check_access

  def show
    @tab = params[:tab].presence_in(%w[requested pending completed]) || "requested"
    @bike_requests = @factory.bike_requests.where(status: @tab)
                             .includes(:distribution_center, :user, :assignee)
                             .order(due_date: :asc)
  end

  private

  def set_factory
    @factory = Factory.find(params[:id])
  end

  def check_access
    require_factory_access(@factory)
  end
end
