class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create, :destroy]
  before_action :set_answer, only: [:destroy]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question
    else
      flash[:notice] = 'Ваш ответ не был сохранен.'
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Ваш ответ был удален.'
    else
      flash[:notice] = 'Вы не являетесь автором ответа.'
    end
    redirect_to @question
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
