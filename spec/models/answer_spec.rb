require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question ) }
  let!(:other_answer) { create(:answer, question: question ) }

  it { should belong_to(:question)}
  it { should validate_presence_of(:body) }

  it 'mark requested answer as best answer' do
    answer.best_switch
    expect(answer).to be_best
  end

  it 'mark only one best answer ' do
    other_answer.best_switch
    expect(answer).to_not be_best
  end

end
