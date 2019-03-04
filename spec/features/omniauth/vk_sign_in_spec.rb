require 'features_helper'

feature 'Sign in with Vkontakte' do

  background do
    visit new_user_session_path
  end

  scenario 'User try to sign in' do
    mock_vk_auth_hash
    click_on 'Sign in with Vkontakte'

    expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    expect(current_path).to eq root_path
  end

  scenario 'User fails vk authentication' do
    mock_invalid_vk_auth_hash
    click_on 'Sign in with Vkontakte'

    expect(page).to have_content "Could not authenticate you from Vkontakte because \"Invalid credentials\"."
  end
end