class UserProductionsController < ApplicationController
  before_action :set_production
  before_action :require_admin

  def create
    user = User.find_by(id: params[:user_id])
    if user.nil?
      redirect_to production_path(@production), alert: "User not found."
      return
    end
    up = @production.user_productions.build(user: user, role: params[:role].presence_in(%w[admin volunteer]) || "volunteer")
    if up.save
      redirect_to production_path(@production), notice: "#{user.name} added."
    else
      redirect_to production_path(@production), alert: up.errors.full_messages.first
    end
  end

  def destroy
    up = @production.user_productions.find(params[:id])
    up.destroy
    redirect_to production_path(@production), notice: "Member removed."
  end

  private

  def set_production
    @production = Production.find(params[:production_id])
  end

  def require_admin
    unless production_admin?(@production)
      render plain: "Access denied", status: :forbidden
    end
  end
end
