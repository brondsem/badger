class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def authorize!
    unless user_signed_in?
      redirect_to root_path
    end
  end

  protected

  # because Devise doesn't know how to permit other database fields
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password) }
  end
end
