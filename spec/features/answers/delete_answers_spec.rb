require_relative '../features_helper'

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
    expect(page).to have_content 'MyAnswerText'
    click_on 'Удалить комментарий'
    expect(page).to have_content 'Ваш ответ был удален.'
    expect(page).to_not have_content 'MyAnswerText'
  end

  scenario 'Authenticated user do not see link to delete other user answer' do
    sign_in(other_user)
    visit question_path(question)
    expect(page).to_not have_content 'Удалить комментарий'
  end

  scenario 'Non-authenticated user do not see link to delete answers' do
    visit question_path(question)
    expect(page).to_not have_content 'Удалить комментарий'
  end

end