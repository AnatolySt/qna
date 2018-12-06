require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_many(:votes).dependent(:destroy) }

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question ) }
  let!(:best_answer) { create(:answer, question: question, best: true ) }

  it { should belong_to(:question)}
  it { should validate_presence_of(:body) }
  it { should have_many :attachments }
  it { should accept_nested_attributes_for :attachments }

  it 'mark requested answer as best answer' do
    answer.best_switch
    expect(answer).to be_best
  end

  it 'mark only one best answer ' do
    answer.best_switch
    expect(best_answer.reload).to_not be_best
  end

end
