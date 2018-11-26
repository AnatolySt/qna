require_relative '../features_helper'

feature 'Add files to question' do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User add files when asks question' do
    fill_in 'question_title', with: 'Test Question Title'
    fill_in 'question_body', with: 'Test Question Body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Отправить'

    expect(page).to have_content 'Test Question Title'
    expect(page).to have_content 'Test Question Body'
    expect(page).to have_content 'spec_helper.rb'
  end
end