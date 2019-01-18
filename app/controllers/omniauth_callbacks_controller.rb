class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_action :set_provider, only: [:vkontakte, :github]
  before_action :make_oauth, only: [:vkontakte, :github]

  def vkontakte
  end

  def github
  end

  private

  def set_provider
    @provider = request.env['omniauth.auth'].provider.capitalize
  end

  def make_oauth
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: @provider) if is_navigational_format?
    else
      redirect_to new_user_session_path
      flash[:alert] = "Произошла ошибка, попробуйте еще раз." if is_navigational_format?
    end
  end

end