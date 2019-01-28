class Answer < ApplicationRecord
  include Votable
  include Commentable

  has_many :attachments, as: :attachable
  belongs_to :question
  belongs_to :user

  after_create :new_answer_notification

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  validates :body, presence: true

  def best_switch
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end

  def new_answer_notification
    NotifySubscribersJob.perform_later(self)
  end

end
