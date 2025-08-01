class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :check_is_user_active 
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def check_is_user_active
    if current_user && !current_user.is_active
      return if request.path == destroy_user_session_path
      render 'users/inactive'
    end
  end

  protected 

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number, :role, :is_active, :email, :username, :bio, :dob, :blood_group, :address, :gender, :tl_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number, :role, :is_active, :email, :username, :bio, :dob, :blood_group, :address, :gender, :tl_id])
  end
end


