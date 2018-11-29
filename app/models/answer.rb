class Answer < ApplicationRecord
  has_many :attachments, as: :attachable
  belongs_to :question
  belongs_to :user

  accepts_nested_attributes_for :attachments

  validates :body, presence: true

  def best_switch
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end

end
