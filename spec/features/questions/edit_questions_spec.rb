require 'features_helper'

feature 'User can update his question' do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  let!(:ability) { Ability.new(user) }

  scenario 'Unauthenticated user do not see edit link' do
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link 'Редактировать вопрос'
    end
  end

  scenario 'Author try to edit his answer', js: true do
    sign_in(user)
    visit question_path(question)
    within '.question' do
      click_on 'Редактировать вопрос'
      fill_in 'question_title', with: 'Отредактированный заголовок'
      fill_in 'question_body', with: 'Отредактированное содержание'
      click_on 'Изменить'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to have_content 'Отредактированный заголовок'
      expect(page).to have_content 'Отредактированное содержание'
      expect(page).to_not have_selector 'textarea'
    end
  end

  scenario 'Authenticated user try to edit not his answer' do
    sign_in(other_user)
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link 'Редактировать вопрос'
    end
  end

end