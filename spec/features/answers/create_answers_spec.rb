require_relative '../features_helper'

feature 'User can answer the question on question page' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

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

  scenario 'Non-authenticated user try to answer the question' do
    visit question_path(question)
    fill_in 'answer_body', with: 'Answer testing'
    click_on 'Отправить'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end