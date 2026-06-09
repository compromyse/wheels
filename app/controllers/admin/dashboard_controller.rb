class Admin::DashboardController < Admin::BaseController
  def index
    @productions = Production.all
    @distributions = Distribution.all
    @users = User.all
  end
end
