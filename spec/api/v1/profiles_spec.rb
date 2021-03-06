require 'rails_helper'

describe 'Profile API' do

  describe 'GET /me' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path("#{attr}")
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end

  end

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    def do_request(options = {})
      get '/api/v1/profiles', params: { format: :json }.merge(options)
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 2) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns 2 users' do
        expect(response.body).to be_json_eql(users.to_json)
      end

      it 'does not return my user profile' do
        expect(response.body).to_not include_json(me.to_json)
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          users.each_with_index do |user, id|
            expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("#{id}/#{attr}")
          end
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          users.each_index do |id|
            expect(response.body).to_not have_json_path("#{id}/#{attr}")
          end
        end
      end
    end
  end

end