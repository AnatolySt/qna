module OmniauthMacros
  def mock_vk_auth_hash
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({
        'provider' => 'vkontakte',
        'uid' => '123456',
        'info' => { 'email' => 'test@user.com' } })
  end

  def mock_invalid_vk_auth_hash
    OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
  end

  def mock_github_auth_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
        'provider' => 'github',
        'uid' => '123456',
        'info' => { 'email' => 'test@user.com' } })
  end

  def mock_invalid_github_auth_hash
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
  end
end