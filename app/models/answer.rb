class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def best_switch
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end

end
