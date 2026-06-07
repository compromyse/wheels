class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:destroy]

  def index
    @users = User.includes(:factories, :distribution_centers).all
  end

  def new
    @user = User.new
    @factories = Factory.all
    @distribution_centers = DistributionCenter.all
  end

  def create
    @user = User.new(user_params)
    if @user.save
      create_location_assignments
      redirect_to admin_users_path, notice: "User added."
    else
      @factories = Factory.all
      @distribution_centers = DistributionCenter.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "User removed."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :superadmin)
  end

  def create_location_assignments
    Array(params[:factory_assignments]).each do |assignment|
      next unless assignment[:enabled] == "1" && assignment[:factory_id].present?
      @user.user_factories.create!(
        factory_id: assignment[:factory_id],
        role: assignment[:role]
      )
    end

    Array(params[:distribution_center_assignments]).each do |assignment|
      next unless assignment[:enabled] == "1" && assignment[:distribution_center_id].present?
      @user.user_distribution_centers.create!(
        distribution_center_id: assignment[:distribution_center_id],
        role: assignment[:role]
      )
    end
  end
end
