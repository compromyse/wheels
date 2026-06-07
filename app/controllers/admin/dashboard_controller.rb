class Admin::DashboardController < Admin::BaseController
  def index
    @factories = Factory.all
    @distribution_centers = DistributionCenter.all
    @users = User.all
  end
end
