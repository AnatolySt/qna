require 'rails_helper'

feature 'User can sign in', %q{
  In order to be able to ask questions
  As an user
  I want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign in' do

    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Unregistered user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123456'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end

end

feature 'Authenticated user can log out' do

  given(:user) { create(:user) }

  scenario 'Authenticated user try to log out' do
    sign_in(user)
    click_on 'Выйти'
    expect(page).to have_content 'Signed out successfully.'
  end

end

feature 'Guest can sign up' do

  scenario 'Guest try to register with valid inputs' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

end