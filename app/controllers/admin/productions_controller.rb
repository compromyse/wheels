class Admin::ProductionsController < Admin::BaseController
  before_action :set_production, only: [:destroy]

  def index
    @productions = Production.all
  end

  def new
    @production = Production.new
  end

  def create
    @production = Production.new(production_params)
    if @production.save
      redirect_to admin_productions_path, notice: "Production added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @production.destroy
    redirect_to admin_productions_path, notice: "Production removed."
  end

  private

  def set_production
    @production = Production.find(params[:id])
  end

  def production_params
    params.require(:production).permit(:name)
  end
end
