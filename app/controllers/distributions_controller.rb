class DistributionsController < ApplicationController
  before_action :set_distribution
  before_action :check_access

  def show
    @tab = params[:tab].presence_in(%w[requested pending completed delivered distributed]) || "requested"
    scope = @distribution.bike_requests.where(status: @tab)
                                .includes(:user, :assignee)
                                .order(due_date: :asc)
    @pagy, @bike_requests = pagy(scope, limit: 20)

    if distribution_admin?(@distribution)
      @members = @distribution.user_distributions.includes(:user).order("users.name")
      if params[:member_query].present?
        query = "%#{params[:member_query]}%"
        assigned_ids = @distribution.users.pluck(:id)
        @member_search_results = User.where("name ILIKE ? OR email ILIKE ?", query, query)
                                     .where.not(id: assigned_ids)
                                     .order(:name).limit(10)
      end
    end
  end

  private

  def set_distribution
    @distribution = Distribution.find(params[:id])
  end

  def check_access
    require_distribution_access(@distribution)
  end
end
