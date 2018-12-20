class AnswersChannel < ApplicationCable::Channel
  def subscribed(data)
    stream_from "question-#{data['id']}"
  end
end