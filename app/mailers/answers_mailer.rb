class AnswersMailer < ApplicationMailer
  def notify_answer(answer, user)
    @question = answer.question
    mail to: user.email
  end
end
