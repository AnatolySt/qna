class SearchesController < ApplicationController

  before_action :authenticate_user!
  before_action :search_types, only: [:new]

  authorize_resource class: false

  def new
  end

  def create
    @search = model_klass.search search_params[:text]
    render :show
  end


  private

  def search_params
    params.require(:search).permit(:type, :text)
  end

  def search_types
    @search_types = {
        thinking_sphinx: "Везде",
        question: "Вопросы",
        answer: "Ответы",
        user: "Пользователи"
    }
  end

  def model_klass
    search_params[:type].to_s.camelize.constantize
  end


end
