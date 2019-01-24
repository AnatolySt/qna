require_relative '../../tures_helper'

feature "User can vote for answer" do

  let(:container) { '.answers' }
  let!(:answer) { create(:answer, question: question, user: author) }

  it_behaves_like 'Vote ability'

end