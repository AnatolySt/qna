require_relative '../features_helper'

feature "Question's author can select the best answer" do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user ) }

  scenario 'Author can select the best answer for his question', js: true do
    sign_in(user)
    visit question_path(question)
    save_and_open_page
    first('.answer').click_on('Назначить ответ лучшим')

    expect(page).to have_css('.best_answer')
  end
end