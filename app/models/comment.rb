class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: :true, optional: :true

  validates :body, presence: true

  def choose_type
    self.commentable_type == 'Question' ? self.commentable.id : self.commentable.question_id
  end

end