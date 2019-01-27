require 'features_helper'

feature 'Show list of questions', %q{
  In order to see community problems
  As an user or guest
  I want to be able to see list of questions
} do

  given!(:questions) { create_list(:question, 3) }

  scenario 'User or guest try to see questions list' do
    visit questions_path
    questions.each do |question|
      expect(page).to have_content "#{question.title}"
    end
  end

end