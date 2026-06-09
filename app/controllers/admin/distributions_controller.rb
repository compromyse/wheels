class Admin::DistributionsController < Admin::BaseController
  before_action :set_distribution, only: [ :edit, :update, :destroy ]

  def index
    @distributions = Distribution.all
  end

  def new
    @distribution = Distribution.new
  end

  def create
    @distribution = Distribution.new(distribution_params)
    if @distribution.save
      redirect_to admin_distributions_path, notice: "Distribution added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @distribution.update(distribution_params)
      redirect_to admin_distributions_path, notice: "Distribution updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @distribution.destroy
    redirect_to admin_distributions_path, notice: "Distribution removed."
  end

  private

  def set_distribution
    @distribution = Distribution.find(params[:id])
  end

  def distribution_params
    params.require(:distribution).permit(:name, :address)
  end
end
