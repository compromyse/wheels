class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:destroy]

  def index
    @users = User.includes(:productions, :distributions).all
  end

  def new
    @user = User.new
    @productions = Production.all
    @distributions = Distribution.all
  end

  def create
    @user = User.new(user_params)
    if @user.save
      create_location_assignments
      redirect_to admin_users_path, notice: "User added."
    else
      @productions = Production.all
      @distributions = Distribution.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @user == current_user
      redirect_to admin_users_path, alert: "You cannot remove yourself."
      return
    end
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
    Array(params[:production_assignments]).each do |assignment|
      next unless assignment[:enabled] == "1" && assignment[:production_id].present?
      @user.user_productions.create!(
        production_id: assignment[:production_id],
        role: assignment[:role]
      )
    end

    Array(params[:distribution_assignments]).each do |assignment|
      next unless assignment[:enabled] == "1" && assignment[:distribution_id].present?
      @user.user_distributions.create!(
        distribution_id: assignment[:distribution_id],
        role: assignment[:role]
      )
    end
  end
end
