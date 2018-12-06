require_relative '../features_helper'

feature "User can vote for answer" do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: author ) }

  context 'Authenticated user' do

    scenario 'User can vote for answer', js: true do
      sign_in(user)
      visit question_path(question)
      within '.answers' do
        first('.answer').click_on('+')
        expect(page).to have_content('Рейтинг: 1')
      end
    end

    scenario "User can't vote for his own answer", js: true do
      sign_in(author)
      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_content '+'
      end
    end

    scenario "User can't vote for answer twice", js: true do
      sign_in(user)
      visit question_path(question)
      within '.answers' do
        first('.answer').click_on('+')
        first('.answer').click_on('+')
        expect(page).to have_content('Рейтинг: 1')
      end
    end

  end

  context 'Non-authenticated user' do

    scenario "Guests can't vote", js: true do
      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_content '+'
      end
    end

  end

end