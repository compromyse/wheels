class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  before_action :require_authentication

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def require_authentication
    redirect_to login_path unless current_user
  end

  def require_superadmin
    render plain: "Access denied", status: :forbidden unless current_user&.superadmin?
  end

  def require_factory_access(factory)
    unless current_user&.factories&.include?(factory)
      render plain: "Access denied", status: :forbidden
    end
  end

  def require_distribution_center_access(dc)
    unless current_user&.distribution_centers&.include?(dc)
      render plain: "Access denied", status: :forbidden
    end
  end
end
