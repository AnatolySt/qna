require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }

  describe 'GET #new' do
    before { get :new, params: { question_id: create(:question)} }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new Answer
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves an answer in database' do
        expect { post :create, params: { question_id: create(:question), answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end
      it 'redirects to question show' do
        post :create, params: { question_id: create(:question), answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
    context 'with invalid attributes' do
      it 'does not saves an answer in database' do
        expect { post :create, params: { question_id: create(:question), answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end
      it 'redirects to question show' do
        post :create, params: { question_id: create(:question), answer: attributes_for(:invalid_answer) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end
end