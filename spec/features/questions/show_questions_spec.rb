require 'rails_helper'

feature 'Show list of questions', %q{
  In order to see community problems
  As an user or guest
  I want to be able to see list of questions
} do

  given(:question) { create(:question) }
  given(:question_second) { create(:question_second) }


  scenario 'User or guest try to see questions list' do
    question
    question_second
    visit questions_path
    expect(page).to have_content 'Список вопросов'
    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyStringSecond'
  end

end