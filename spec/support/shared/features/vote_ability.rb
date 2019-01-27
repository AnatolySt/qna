require 'rails_helper'

shared_examples_for 'Vote ability' do

  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: author) }

  context 'Authenticated user' do

    scenario 'User can vote for object', js: true do
      sign_in(user)
      visit question_path(question)
      within container do
        click_on '+'
        expect(page).to have_content('Рейтинг: 1')
      end
    end

    scenario "User can't vote for his own object", js: true do
      sign_in(author)
      visit question_path(question)
      within container do
        expect(page).to_not have_content '+'
      end
    end

    scenario "User can't vote for object", js: true do
      sign_in(user)
      visit question_path(question)
      within container do
        click_on '+'
        wait_for_ajax
        click_on '+'
        wait_for_ajax
        expect(page).to have_content('Рейтинг: 1')
      end
    end

  end

  context 'Non-authenticated user' do
    scenario "Guests can't vote" do
      visit question_path(question)
      within container do
        expect(page).to_not have_content '+'
      end
    end
  end

end