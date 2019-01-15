class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  before_action :gon_user, unless: :devise_controller?

  private

  def gon_user
    gon.current_user_id = current_user.id if current_user
  end


end
