require_relative '../features_helper'

feature 'Sign in with Github' do

  background do
    visit new_user_session_path
  end

  scenario 'User try to sign in' do
    mock_github_auth_hash
    click_on 'Sign in with GitHub'

    expect(page).to have_content 'Successfully authenticated from Github account.'
    expect(current_path).to eq root_path
  end

  scenario 'User fails github authentication' do
    mock_invalid_github_auth_hash
    click_on 'Sign in with GitHub'

    expect(page).to have_content "Could not authenticate you from GitHub because \"Invalid credentials\"."
  end
end