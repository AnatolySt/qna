class AnswersController < ApplicationController

  before_action :set_question, only: [:create]

  def new
    @answer = Answer.new
  end

  def create
    if @question.answers.create(answer_params)
      redirect_to @question
    else
      redirect_to @question
    end
  end

  private

  def set_question
    @question = Question.find_by_id(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
