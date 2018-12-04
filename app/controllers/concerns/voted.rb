module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down]
  end

  def vote_up
    unless current_user.author_of?(@votable)
      @votable.vote_up(current_user)
      render_votable
    end
  end

  def vote_down
    unless current_user.author_of?(@votable)
      @votable.vote_down(current_user)
      render_votable
    end
  end

  private

  def render_votable
    render json: @votable.rating
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

end