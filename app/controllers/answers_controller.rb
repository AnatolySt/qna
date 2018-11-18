class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create, :update, :destroy, :mark_best]
  before_action :set_answer, only: [:update, :destroy, :mark_best]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
    end
  end

  def mark_best
    @question.answers.each do |answer|
      answer.best_flag = false
      answer.save
    end
    @answer.best_flag = true
    @answer.save
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :best_flag)
  end

end