require 'rails_helper'

describe Ability do

  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:question) { create(:question, user: user ) }
    let(:other_question) { create(:question, user: other ) }
    let(:answer) { create(:answer, question: question, user: user ) }
    let(:other_answer) { create(:answer, user: other ) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :destroy, Question, user: user }

      it { should be_able_to :update, question, user: user}
      it { should_not be_able_to :update, other_question, user: user }

      it { should be_able_to :vote_up, other_question, user: user }
      it { should be_able_to :vote_down, other_question, user: user }
      it { should_not be_able_to :vote_up, question, user: user }
      it { should_not be_able_to :vote_down, question, user: user }
    end


    context 'Answer' do
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, answer, user: user }
      it { should_not be_able_to :update, other_answer, user: user }

      it { should be_able_to :vote_up, other_answer, user: user }
      it { should be_able_to :vote_down, other_answer, user: user }
      it { should_not be_able_to :vote_up, answer, user: user }
      it { should_not be_able_to :vote_down, answer, user: user }

      it { should be_able_to :best, answer, user: user }
      it { should_not be_able_to :best, other_answer, user: user }
    end

    context 'comment' do
      it { should be_able_to :create, Comment }
    end
  end

end