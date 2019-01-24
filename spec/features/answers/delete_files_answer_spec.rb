require_relative '../../tures_helper'

feature "Delete answer's files" do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: user ) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  scenario "Author delete answer's files", js: true do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      accept_alert do
        click_on 'Удалить файл'
      end
      expect(page).to_not have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end

  scenario "Non-author delete answer's files", js: true do
    sign_in(other_user)
    visit question_path(question)
    expect(page).to_not have_link 'Удалить файл'
  end

end