class CommentsController < ApplicationController

  before_action :set_commentable, only: :create
  after_action :publish_comment, only: :create

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      render :create
    else
      render json: @comment.errors.full_messages
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    if params[:question_id].present?
      @commentable = Question.find(params[:question_id])
    elsif params[:answer_id].present?
      @commentable = Answer.find(params[:answer_id])
    end
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
                          "comments-for-#{@comment.commentable_type == 'Question' ? @commentable.id : @commentable.question_id }",
                          @comment
    )
  end

end
