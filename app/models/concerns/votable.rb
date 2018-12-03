module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
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
    if votes.where(user: user, value: value).exists?
      votes.where(user: user).first.destroy
    else
      votes.create!(value: value, user: user)
    end
  end

end