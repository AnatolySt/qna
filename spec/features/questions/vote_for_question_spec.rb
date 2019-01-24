require_relative "../features_helper.rb"

feature "User can vote for question" do

  let(:container) { '.question' }

  it_behaves_like 'Vote ability'

end