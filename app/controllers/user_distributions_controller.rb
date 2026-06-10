class UserDistributionsController < ApplicationController
  before_action :set_distribution
  before_action :require_admin

  def create
    user = User.find_by(id: params[:user_id])
    if user.nil?
      redirect_to distribution_path(@distribution), alert: "User not found."
      return
    end
    ud = @distribution.user_distributions.build(user: user, role: params[:role].presence_in(%w[admin volunteer]) || "volunteer")
    if ud.save
      redirect_to distribution_path(@distribution), notice: "#{user.name} added."
    else
      redirect_to distribution_path(@distribution), alert: ud.errors.full_messages.first
    end
  end

  def destroy
    ud = @distribution.user_distributions.find(params[:id])
    ud.destroy
    redirect_to distribution_path(@distribution), notice: "Member removed."
  end

  private

  def set_distribution
    @distribution = Distribution.find(params[:distribution_id])
  end

  def require_admin
    unless distribution_admin?(@distribution)
      render plain: "Access denied", status: :forbidden
    end
  end
end
