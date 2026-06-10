class UserProductionsController < ApplicationController
  before_action :set_production
  before_action :require_admin

  def create
    user = User.find_by(id: params[:user_id])
    if user.nil?
      redirect_to users_production_path(@production), alert: "User not found."
      return
    end
    up = @production.user_productions.build(user: user, role: params[:role].presence_in(UserProduction::ROLES) || "volunteer")
    if up.save
      redirect_to users_production_path(@production), notice: "#{user.name} added."
    else
      redirect_to users_production_path(@production), alert: up.errors.full_messages.first
    end
  end

  def update
    up = @production.user_productions.find(params[:id])
    role = params[:role].presence_in(UserProduction::ROLES)
    if role && up.update(role: role)
      redirect_to users_production_path(@production), notice: "Role updated."
    else
      redirect_to users_production_path(@production), alert: "Invalid role."
    end
  end

  def destroy
    up = @production.user_productions.find(params[:id])
    up.destroy
    redirect_to users_production_path(@production), notice: "Member removed."
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
