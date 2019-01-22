class CommentsController < ApplicationController

  before_action :set_commentable, only: :create
  after_action :publish_comment, only: :create

  respond_to :js, :json

  authorize_resource

  def create
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
    respond_with @comment
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    @commentable = Question.find(params[:question_id]) if params[:question_id]
    @commentable ||= Answer.find(params[:answer_id])
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast("comments-for-#{@comment.choose_type}", @comment)
  end

end
