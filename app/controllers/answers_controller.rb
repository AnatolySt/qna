class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:update, :destroy, :mark_best]

  after_action :publish_answer, only: [:create]

  respond_to :js, :json

  authorize_resource

  def new
    respond_with(@answer = Answer.new)
  end

  def create
    @answer = current_user.answers.create(answer_params.merge(question_id: @question.id))
    respond_with(@answer)
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def mark_best
    respond_with(@answer.best_switch)
  end

  private

  def publish_answer
    return if @answer.errors.any?

    attachments = []
    @answer.attachments.each do |a|
      attachments << { id: a.id, url: a.file.url, name: a.file.identifier }
    end

    data = {
        answer: @answer,
        question_user_id: @question.user_id,
        answer_rating: @answer.rating,
        attachments: attachments
    }

    ActionCable.server.broadcast("question-#{@question.id}", data )
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

end