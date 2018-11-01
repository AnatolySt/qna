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
    save_and_open_page
    fill_in 'question_title', with: 'Test Question Title'
    fill_in 'question_body', with: 'Test Question Body'
    click_on 'Отправить'

    expect(page).to have_content 'Test Question Title'
    expect(page).to have_content 'Test Question Body'
  end

  scenario 'Non-authenticated user try to ask question' do
    visit questions_path
    click_on 'Создать вопрос'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end

feature 'Show list of questions', %q{
  In order to see community problems
  As an user or guest
  I want to be able to see list of questions
} do

  scenario 'User or guest try to see questions list' do
    visit questions_path
    expect(page).to have_content 'Список вопросов'
  end

end

feature 'Show question and answers for' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    create(:answer, question_id: question.id)
  end

  scenario 'User try to see the question and answers for' do
    sign_in(user)
    visit question_path(question.id)
    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'
    expect(page).to have_content 'MyAnswerText'
  end

end

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

end

feature 'User can delete his answer' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:other_user) { create(:user) }

  background do
    create(:answer, question: question, user: user )
  end

  scenario 'Authenticated user try to delete his answer' do
    sign_in(user)
    visit question_path(question)
    click_on 'Удалить комментарий'
    expect(page).to have_content 'Ваш ответ был удален.'
  end

  scenario 'Authenticated user do not see link to delete other user answer' do
    sign_in(other_user)
    visit question_path(question)
    expect(page).to_not have_content 'Удалить комментарий'
  end



end