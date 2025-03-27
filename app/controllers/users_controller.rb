class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :show]

  # Display all users (only for admins and hr)
  def index
    @users = User.all.page(params[:page]).per(10)

    if params[:role].present?
      @users = @users.where(role: params[:role]).page(params[:page]).per(10)
    end
  end

  # Edit a user
  def edit
  end

	def show 
	end 

  # Update a user
  def update
    if @user.update(user_params)
      redirect_to users_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # Destroy a user
  def destroy
    @user.destroy
    redirect_to users_path, notice: 'User was successfully deleted.'
  end

  private

  # Set the user based on ID
  def set_user
    @user = User.find(params[:id])
  end

  # Strong parameters for user
  def user_params
    params.require(:user).permit(:email, :role, :first_name, :last_name, :username, :avatar, :bio, :phone_number, :dob, :is_active, :blood_group, :address, :gender, :is_active)
  end
end
