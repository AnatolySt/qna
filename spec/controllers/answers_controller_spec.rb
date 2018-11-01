require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'GET #new' do
    sign_in_user
    before { get :new, params: { question_id: question, user_id: user } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new Answer
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      sign_in_user
      it 'saves an answer in database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end
      it 'redirects to question show' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
    context 'with invalid attributes' do
      sign_in_user
      it 'does not saves an answer in database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end
      it 'redirects to question show' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let(:author_answer) { create(:answer, question: question, user: @user) }


    it 'deletes answer' do
      author_answer
      expect { delete :destroy, params: { id: author_answer, question_id: question } }.to change(question.answers, :count).by(-1)
    end

    it 'redirect to index view' do
      delete :destroy, params: { question_id: question.id, id: answer.id }
      expect(response).to redirect_to question_path(question)
    end

  end
end