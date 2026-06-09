class DistributionsController < ApplicationController
  before_action :set_distribution
  before_action :check_access

  def show
    @tab = params[:tab].presence_in(%w[requested pending completed delivered distributed]) || "requested"
    scope = @distribution.bike_requests.where(status: @tab)
                                .includes(:user, :assignee)
                                .order(due_date: :asc)
    @pagy, @bike_requests = pagy(scope, limit: 20)
  end

  private

  def set_distribution
    @distribution = Distribution.find(params[:id])
  end

  def check_access
    require_distribution_access(@distribution)
  end
end
