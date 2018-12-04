module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, inverse_of: :votable, dependent: :destroy
  end

  def vote_up(user)
    vote(1, user)
  end

  def vote_down(user)
    vote(-1, user)
  end

  def rating
    votes.sum(:value)
  end

  private

  def vote(value, user)
    ex_vote = votes.where(user: user, value: value)
    if ex_vote.exists?
      ex_vote.first.destroy
    else
      votes.create!(value: value, user: user)
    end
  end

end