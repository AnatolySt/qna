class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: :show

  after_action :publish_question, only: [:create]

  respond_to :js, :json

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    @question = Question.new
    @question.attachments.build
    respond_with(@question)
  end

  def create
    @question = current_user.questions.create(question_params)
    respond_with @question
  end

  def edit
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
        'questions',
        ApplicationController.render(
          partial: 'questions/question_list',
          locals: { question: @question }
        )
    )
  end

  def build_answer
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
