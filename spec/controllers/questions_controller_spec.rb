require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted'

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question.id } }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render the question view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new Question
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves a question in database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders the new view' do
        post :create, params: { question: attributes_for(:invalid_question)}
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, params: { id: question.id } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
  end

  describe 'PATCH #update' do

    before do
      sign_in(user)
    end

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question.id, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end
      it 'updates the attributes' do
        patch :update, params: { id: question.id, question: { title: 'MyString', body: 'MyText' }, format: :js }
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end
      it 'redirects to the updated question' do
        patch :update, params: { id: question.id, question: attributes_for(:question), format: :js }
        expect(response).to render_template :update
      end
    end
    context 'with invalid attributes' do
      before { patch :update, params: { id: question.id, question: { title: nil, body: nil }, format: :js } }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to match 'MyString'
        expect(question.body).to eq 'MyText'
      end
    end
  end


  describe 'DELETE #destroy' do
    sign_in_user
    let!(:author_question) { create(:question, user: @user) }

    context 'author delete his question' do
      it 'deletes question' do
        expect { delete :destroy, params: { id: author_question } }.to change(Question, :count).by(-1)
      end
    end

    context 'user trying to delete not his question' do
      it 'not deletes question' do
        question
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
    end
  end
end
