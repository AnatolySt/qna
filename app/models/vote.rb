class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates_uniqueness_of :user_id, scope: %i[value votable_type votable_id]

end

