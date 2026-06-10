class RegistrationsController < ApplicationController
  skip_before_action :require_authentication

  before_action :redirect_if_authenticated

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Welcome to Wheels, #{@user.name}!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def redirect_if_authenticated
    redirect_to root_path if current_user
  end

  def registration_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
