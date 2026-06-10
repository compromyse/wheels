class Admin::BaseController < ApplicationController
  before_action :require_superadmin
  before_action :set_admin_nav

  private

  def set_admin_nav
    @location_name = "Admin Panel"
    @location_path = admin_root_path
    @location_admin = false
  end
end
