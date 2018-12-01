require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do
    context 'with valid attributes' do
      sign_in_user
      it 'saves an answer in database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end
      it 'saved answer belongs to signed_in user' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(@user.answers, :count).by(1)
      end
      it 'render create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end
    context 'with invalid attributes' do
      sign_in_user
      it 'does not saves an answer in database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js } }.to_not change(Answer, :count)
      end
      it 'redirects to question show' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let(:author_answer) { create(:answer, question: question, user: @user) }

    context 'author delete his answer' do
      it 'deletes answer' do
        author_answer
        expect { delete :destroy, params: { id: author_answer, question_id: question }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { question_id: question.id, id: answer.id, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'user trying to delete not his answer' do
      it 'not deletes answer' do
        answer
        expect { delete :destroy, params: { id: answer, question_id: question, format: :js } }.to_not change(question.answers, :count)
      end

      it 'redirect to index view' do
        delete :destroy, params: { question_id: question.id, id: answer.id, format: :js }
        expect(response).to render_template :destroy
      end
    end

    describe 'PATCH #update' do
      sign_in_user
      context 'with valid attributes' do
        it 'assigns the requested answer to @answer' do
          patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
          expect(assigns(:answer)).to eq answer
        end
        it 'updates the attributes' do
          patch :update, params: { id: answer, question_id: question, answer: { body: 'new body'}, format: :js }
          answer.reload
          expect(answer.body).to eq 'new body'
        end
        it 'render update template' do
          patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
          expect(response).to render_template :update
        end
      end
    end


  end
end