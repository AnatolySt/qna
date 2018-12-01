require_relative '../features_helper'

feature 'User can update his answer' do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user ) }

  scenario 'Unauthenticated user do not see edit link' do
    visit question_path(question)
    expect(page).to_not have_link 'Редактировать'
  end

  scenario 'Author try to edit his answer', js: true do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      click_on 'Редактировать'
      fill_in 'answer_body', with: 'Отредактированный ответ'
      click_on 'Отправить'

      expect(page).to_not have_content answer.body
      expect(page).to have_content 'Отредактированный ответ'
      expect(page).to_not have_selector 'textarea'
    end
  end

  scenario 'Authenticated user try to edit not his answer' do
    sign_in(other_user)
    visit question_path(question)
    expect(page).to_not have_link 'Редактировать'
  end

end