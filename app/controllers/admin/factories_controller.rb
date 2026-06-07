class Admin::FactoriesController < Admin::BaseController
  before_action :set_factory, only: [:destroy]

  def index
    @factories = Factory.all
  end

  def new
    @factory = Factory.new
  end

  def create
    @factory = Factory.new(factory_params)
    if @factory.save
      redirect_to admin_factories_path, notice: "Factory added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @factory.destroy
    redirect_to admin_factories_path, notice: "Factory removed."
  end

  private

  def set_factory
    @factory = Factory.find(params[:id])
  end

  def factory_params
    params.require(:factory).permit(:name)
  end
end
