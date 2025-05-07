class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :show]

  # Display all users (only for admins and hr)
  def index
    if current_user.admin? || current_user.hr?
      @users = User.all.order(created_at: :desc)
      if params[:search].present?
        term = "%#{params[:search]}%"
        @users = @users.where("first_name LIKE :term OR last_name LIKE :term OR email LIKE :term", term: term)
      end

      @users = @users.page(params[:page]).per(10)

      if params[:role].present?
        @users = @users.where(role: params[:role]).page(params[:page]).per(10)
        respond_to do |format|
          format.html
          format.turbo_stream { render partial: "users_list", locals: { users: @users } }
        end
      end
    else 
      redirect_to root_path, alert: 'You are not authorized to view this page.'
    end   
  end

  def new 
    @user = User.new
  end 

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: 'User successfully created.'
    else
      render :new
    end
  end

  # Edit a user
  def edit
    if (current_user.admin? || current_user.hr?) || (current_user.id == @user.id)
      # Allow the user to edit their own profile or if they are an admin or HR
    else
      redirect_to users_path, alert: 'You are not authorized to edit this profile.'
    end
  end

	def show 
    if (current_user.admin? || current_user.hr?) || (current_user.id == @user.id)
      # Allow the user to edit their own profile or if they are an admin or HR
    else
      redirect_to users_path, alert: 'You are not authorized to edit this profile.'
    end
	end 

  # Update a user
  def update
    if (current_user.admin? || current_user.hr?) || (current_user.id == @user.id)
      if @user.update(user_params)
        redirect_to users_path, notice: 'User was successfully updated.'
      else
        render :edit
      end
    else
      redirect_to users_path, alert: 'You are not authorized to edit this profile.'
    end
  end

  # Destroy a user
  def destroy
    @user.destroy
  
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to users_path, notice: 'User was successfully deleted.' }
    end
  end

  def inactive
    # You can set up any logic for the inactive page here if needed
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
