class AnswersController < ApplicationController

  before_action :set_question, only: [:create]

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(answer_params)

    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  private

  def set_question
    @question = Question.find_by_id(answer_params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
