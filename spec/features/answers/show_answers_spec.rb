require_relative '../features_helper'

feature 'Show question and answers for' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question_id: question.id) }

  scenario 'User try to see the question and answers for' do
    sign_in(user)
    visit question_path(question.id)
    answers.each do |answer|
      expect(page).to have_content "#{answer.body}"
    end
  end

end