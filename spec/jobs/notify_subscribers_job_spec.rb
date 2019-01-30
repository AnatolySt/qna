require 'rails_helper'

RSpec.describe NotifySubscribersJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  it 'notify users about new answer' do
    expect(AnswersMailer).to receive(:notify_answer).with(answer, user).and_call_original
    NotifySubscribersJob.perform_now(answer)
  end
end