class AnswersMailer < ApplicationMailer
  def notify_question_author(answer)
    @question = answer.question
    mail to: @question.user.email
  end
end
