require 'features_helper'

feature 'User can answer the question on question page' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'Authenticated user' do

    scenario 'Authenticated user try to answer the question', js: true do
      sign_in(user)
      visit question_path(question)
      fill_in 'answer_body', with: 'Answer testing'
      click_on 'Отправить'
      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Answer testing'
      end
    end

    scenario 'Authenticated user try to answer the question with invalid attributes', js: true do
      sign_in(user)
      visit question_path(question)
      fill_in 'answer_body', with: nil
      click_on 'Отправить'
      expect(page).to have_content "Body can't be blank"
    end

  end

  context 'Multiple sessions' do

    scenario "Answer appears on another user's page", js: true do

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end


      Capybara.using_session('user') do
        fill_in 'answer_body', with: 'Test Answer Body'
        click_on 'Отправить'

        expect(page).to have_content 'Test Answer Body'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test Answer Body'
      end

    end

  end

  context 'Non-authenticated user' do

    scenario 'Non-authenticated user try to answer the question' do
      visit question_path(question)
      fill_in 'answer_body', with: 'Answer testing'
      click_on 'Отправить'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

  end

end