class Admin::DistributionCentersController < Admin::BaseController
  before_action :set_distribution_center, only: [:destroy]

  def index
    @distribution_centers = DistributionCenter.all
  end

  def new
    @distribution_center = DistributionCenter.new
  end

  def create
    @distribution_center = DistributionCenter.new(distribution_center_params)
    if @distribution_center.save
      redirect_to admin_distribution_centers_path, notice: "Distribution center added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @distribution_center.destroy
    redirect_to admin_distribution_centers_path, notice: "Distribution center removed."
  end

  private

  def set_distribution_center
    @distribution_center = DistributionCenter.find(params[:id])
  end

  def distribution_center_params
    params.require(:distribution_center).permit(:name)
  end
end
