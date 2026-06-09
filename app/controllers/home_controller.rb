class HomeController < ApplicationController
  def index
    if current_user.superadmin? && current_user.all_locations.empty?
      redirect_to admin_root_path and return
    end

    if current_user.single_location?
      location = current_user.all_locations.first
      case location
      when Production
        redirect_to production_path(location) and return
      when Distribution
        redirect_to distribution_path(location) and return
      end
    end

    @productions = current_user.productions
    @distributions = current_user.distributions
  end
end
