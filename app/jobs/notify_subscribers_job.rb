class NotifySubscribersJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.each do |subscription|
      AnswersMailer.notify_answer(self, subscription.user).deliver_later
    end
  end
end