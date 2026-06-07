class HomeController < ApplicationController
  def index
    if current_user.superadmin? && current_user.all_locations.empty?
      redirect_to admin_root_path and return
    end

    if current_user.single_location?
      location = current_user.all_locations.first
      case location
      when Factory
        redirect_to factory_path(location) and return
      when DistributionCenter
        redirect_to distribution_center_path(location) and return
      end
    end

    @factories = current_user.factories
    @distribution_centers = current_user.distribution_centers
  end
end
