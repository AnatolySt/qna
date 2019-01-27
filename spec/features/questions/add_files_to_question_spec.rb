require 'features_helper'

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
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'User add multiple files when asks the question', js: true do
    fill_in 'question_title', with: 'Test Question Title'
    fill_in 'question_body', with: 'Test Question Body'
    click_on 'Добавить еще файл'
    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'Отправить'
    save_and_open_page

    within '.question' do
      expect(page).to have_content 'Test Question Title'
      expect(page).to have_content 'Test Question Body'
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/3/rails_helper.rb'
    end
  end

end