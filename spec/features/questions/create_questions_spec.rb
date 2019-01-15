require_relative '../features_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  context 'Authenticated user' do

    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'Authenticated user try to ask question' do
      click_on 'Создать вопрос'
      fill_in 'question_title', with: 'Test Question Title'
      fill_in 'question_body', with: 'Test Question Body'
      click_on 'Отправить'

      expect(page).to have_content 'Test Question Title'
      expect(page).to have_content 'Test Question Body'
    end

    scenario 'Authenticated user try to ask question with invalid attributes' do
      click_on 'Создать вопрос'
      fill_in 'question_title', with: nil
      fill_in 'question_body', with: nil
      click_on 'Отправить'

      expect(page).to have_content 'Ошибка. Попробуйте еще раз.'
      expect(page).to have_content "Body can't be blank"
      expect(page).to have_content "Title can't be blank"
    end

  end

  context 'Multiple-sessions' do

    scenario "Question appears on another user's page", js: true do

      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end


      Capybara.using_session('user') do
        click_on 'Создать вопрос'
        fill_in 'question_title', with: 'Test Question Title'
        fill_in 'question_body', with: 'Test Question Body'
        click_on 'Отправить'

        expect(page).to have_content 'Test Question Title'
        expect(page).to have_content 'Test Question Body'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test Question Title'
      end


    end

  end

  context 'Non-authenticated user' do

    scenario 'Non-authenticated user try to ask question' do
      visit questions_path
      click_on 'Создать вопрос'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

  end

end