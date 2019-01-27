require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:model) { create(described_class.to_s.underscore.to_sym) }
  let(:user) { create(:user) }

  describe '#vote_up' do

    it 'creates new vote' do
      expect { model.vote_up(user) }.to change(model.votes, :count).by(1)
    end
    it 'change votes value by 1' do
      model.vote_up(user)
      expect(model.votes.sum(:value)).to eq(1)
    end
    it 'destroys vote if one already exist' do
      2.times { model.vote_up(user) }
      expect(model.votes.sum(:value)).to eq(0)
    end
  end

  describe '#vote_down' do

    it 'creates new vote' do
      expect { model.vote_down(user) }.to change(model.votes, :count).by(1)
    end
    it 'change votes value by -1' do
      model.vote_down(user)
      expect(model.votes.sum(:value)).to eq(-1)
    end
    it 'destroys vote if one already exist' do
      2.times { model.vote_down(user) }
      expect(model.votes.sum(:value)).to eq(0)
    end

  end

  describe '#rating' do
    let(:users) { create_list(:user, 3) }

    it 'shows the sum of all votes' do
      users.each { |u| model.vote_up(u) }
      expect(model.rating).to eq(3)
    end

  end
end