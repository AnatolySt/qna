require 'rails_helper'

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