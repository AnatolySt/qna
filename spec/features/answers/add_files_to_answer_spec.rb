require 'features_helper'

feature 'Add files to answer' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User add files when answers the question', js: true do
    fill_in 'answer_body', with: 'Test Answer Body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Отправить'
    save_and_open_page
    within '.answers' do
      expect(page).to have_content 'Test Answer Body'
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'User add multiple files when answers the question', js: true do
    fill_in 'answer_body', with: 'Test Answer Body'
    click_on 'Добавить еще файл'
    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'Отправить'

    within '.answers' do
      expect(page).to have_content 'Test Answer Body'
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
end