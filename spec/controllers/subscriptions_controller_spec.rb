require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do

  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    sign_in_user
    it 'saves an subscription in database' do
      expect { post :create, params: { question_id: question, format: :js } }.to change(Subscription, :count).by(1)
    end

    it 'render create template' do
      post :create, params: { question_id: question, format: :js }
      expect(response).to render_template :create
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:subscription) { create(:subscription, user: user, question: question) }

    it 'deletes subscription' do
      expect { delete :destroy, params: { id: subscription.id }, format: :js }.to change(Subscription, :count).by(-1)
    end

    it 'redirect to index view' do
      delete :destroy, params: { id: subscription.id, format: :js }
      expect(response).to render_template :destroy
    end

  end

end