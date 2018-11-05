require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user try to ask question' do
    sign_in(user)

    visit questions_path
    click_on 'Создать вопрос'
    fill_in 'question_title', with: 'Test Question Title'
    fill_in 'question_body', with: 'Test Question Body'
    click_on 'Отправить'

    expect(page).to have_content 'Test Question Title'
    expect(page).to have_content 'Test Question Body'
  end

  scenario 'Authenticated user try to ask question with invalid attributes' do
    sign_in(user)

    visit questions_path
    click_on 'Создать вопрос'
    fill_in 'question_title', with: nil
    fill_in 'question_body', with: nil
    click_on 'Отправить'

    expect(page).to have_content 'Ошибка. Попробуйте еще раз.'
  end

  scenario 'Non-authenticated user try to ask question' do
    visit questions_path
    click_on 'Создать вопрос'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end