require 'rails_helper'

feature 'User can answer the question on question page' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user try to answer the question' do
    sign_in(user)
    visit question_path(question.id)
    fill_in 'answer_body', with: 'Answer testing'
    click_on 'Отправить'
    expect(page).to have_content 'Answer testing'
  end

  scenario 'Authenticated user try to answer the question with invalid attributes' do
    sign_in(user)
    visit question_path(question.id)
    fill_in 'answer_body', with: nil
    click_on 'Отправить'
    expect(page).to have_content 'Ваш ответ не был сохранен.'
  end

  scenario 'Non-authenticated user try to answer the question' do
    visit question_path(question.id)
    fill_in 'answer_body', with: 'Answer testing'
    click_on 'Отправить'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end