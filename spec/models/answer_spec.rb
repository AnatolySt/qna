require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question ) }
  let!(:answers) { create_list(:answer, 3, question: question) }
  let!(:best_answer) { create(:answer, question: question, best: true ) }

  it { should belong_to(:question)}
  it { should validate_presence_of(:body) }

  it 'mark requested answer as best answer' do
    answer.best_switch
    expect(answer.best).to eq true
    answers.each do |answer|
      expect(answer.best).to eq false
    end
  end

  it 'mark other answer as best answer when best answer already selected' do
    answer.best_switch
    expect(answer.best).to eq true
    answers.each do |answer|
      expect(answer.best).to eq false
    end
    expect(best_answer.reload.best).to eq false
  end

end
