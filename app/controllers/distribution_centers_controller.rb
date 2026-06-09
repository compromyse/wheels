class DistributionCentersController < ApplicationController
  before_action :set_distribution_center
  before_action :check_access

  def show
    @tab = params[:tab].presence_in(%w[requested pending completed]) || "requested"
    scope = @distribution_center.bike_requests.where(status: @tab)
                                .includes(:user, :assignee)
                                .order(due_date: :asc)
    @pagy, @bike_requests = pagy(scope, limit: 20)
  end

  private

  def set_distribution_center
    @distribution_center = DistributionCenter.find(params[:id])
  end

  def check_access
    require_distribution_center_access(@distribution_center)
  end
end
