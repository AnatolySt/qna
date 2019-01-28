require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'commentable'
  it_behaves_like 'attachable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
end
