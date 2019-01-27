require 'rails_helper'

shared_examples 'voted' do

  resource_name = described_class.controller_name.singularize.to_sym

  sign_in_user

  let(:resource) { create(resource_name) }
  let(:resource_params) { { id: resource } }
  let(:owned_resource) { create(resource_name, user: @user) }
  let(:owned_resource_params) { { id: resource } }

  before do
    if resource_name == :answer
      resource_params[:question_id] = resource.question
      owned_resource_params[:question_id] = resource.question
    end
  end

  describe 'POST #vote_up' do

    context 'resource non-owner' do
      it 'increase votes by 1' do
        post :vote_up, params: resource_params, format: :js
        expect(resource.rating).to eq(1)
      end

      it 'saves the vote in database' do
        expect { post :vote_up, params: resource_params, format: :js }.to change(resource.votes, :count).by(1)
      end
    end


    context 'resource owner' do
      it 'not increase votes' do
        post :vote_up, params: owned_resource_params, format: :js
        expect(owned_resource.rating).to eq(0)
      end

      it 'saves the vote in database' do
        expect { post :vote_up, params: owned_resource_params, format: :js }.to_not change(owned_resource.votes, :count)
      end
    end

  end

  describe 'POST #vote_down' do
    context 'resource non-owner' do

      it 'decrease votes by 1' do
        post :vote_down, params: resource_params, format: :js
        expect(resource.rating).to eq(-1)
      end

      it 'saves the vote in database' do
        expect { post :vote_up, params: resource_params, format: :js }.to change(resource.votes, :count).by(1)
      end
    end


    context 'resource owner' do
      it 'not increase votes' do
        post :vote_up, params: owned_resource_params, format: :js
        expect(owned_resource.rating).to eq(0)
      end

      it 'saves the vote in database' do
        expect { post :vote_up, params: owned_resource_params, format: :js }.to_not change(owned_resource.votes, :count)
      end
    end
  end

end