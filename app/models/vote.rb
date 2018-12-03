class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validate :vote_only_once

  private

  def vote_only_once
    if Vote.where(user_id: user).where(votable_id: votable).exists?
      errors.add(:votes_count, "can't be greater than one")
    end
  end

end

