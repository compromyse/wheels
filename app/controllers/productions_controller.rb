class ProductionsController < ApplicationController
  before_action :set_production
  before_action :check_access

  def show
    @tab = params[:tab].presence_in(%w[requested pending completed delivered distributed]) || "requested"
    scope = @production.bike_requests.where(status: @tab)
                    .includes(:distribution, :user, :assignee)
                    .order(due_date: :asc)
    @pagy, @bike_requests = pagy(scope, limit: 20)
  end

  private

  def set_production
    @production = Production.find(params[:id])
  end

  def check_access
    require_production_access(@production)
  end
end
