require 'features_helper'

feature "User can vote for question" do

  let(:container) { '.question' }

  it_behaves_like 'Vote ability'

end