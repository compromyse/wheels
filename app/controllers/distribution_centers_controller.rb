class DistributionCentersController < ApplicationController
  before_action :set_distribution_center
  before_action :check_access

  def show
  end

  private

  def set_distribution_center
    @distribution_center = DistributionCenter.find(params[:id])
  end

  def check_access
    require_distribution_center_access(@distribution_center)
  end
end
