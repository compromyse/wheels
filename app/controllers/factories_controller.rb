class FactoriesController < ApplicationController
  before_action :set_factory
  before_action :check_access

  def show
  end

  private

  def set_factory
    @factory = Factory.find(params[:id])
  end

  def check_access
    require_factory_access(@factory)
  end
end
