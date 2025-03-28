class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :check_is_user_active 

  private

  def check_is_user_active
    if current_user && !current_user.is_active
      return if request.path == destroy_user_session_path
      render 'users/inactive'
    end
  end
end
