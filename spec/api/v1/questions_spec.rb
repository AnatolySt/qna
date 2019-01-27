require 'rails_helper'

describe 'Questions API' do

  describe 'GET /index' do

    it_behaves_like 'API Authenticable'

    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end

    context 'authorized' do
      let(:access_token) { create(:access_token).token }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token } }

      it 'returns 200 status code' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "returns #{attr} field" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('0/short_title')
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('0/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "return #{attr} field" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /show' do
    let(:question) { create(:question) }

    it_behaves_like 'API Authenticable'

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end

    context 'authorized' do
      let(:access_token) { create(:access_token).token }
      let!(:attachment) { create(:attachment, attachable: question) }
      let!(:comment) { create(:question_comment, commentable: question) }

      it_behaves_like 'API Commentable'
      it_behaves_like 'API Attachable'

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token } }

      it 'returns 200 status code' do
        expect(response).to be_successful
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end
    end
  end

  describe 'POST /create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        post "/api/v1/questions", params: { format: :json, question: attributes_for(:question) }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        post "/api/v1/questions", params: { format: :json, question: attributes_for(:question) }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token).token }

      context 'question with valid attributes' do
        it 'returns 200 status code' do
          post "/api/v1/questions", params: { format: :json, question: attributes_for(:question), access_token: access_token }
          expect(response).to be_successful
        end

        it 'saves the new question in database' do
          expect { post "/api/v1/questions", params: {
              format: :json, question: attributes_for(:question), access_token: access_token }
          }.to change(Question, :count).by(1)
        end
      end


      context 'with invalid attributes' do
        it 'returns 422 status code' do
          post "/api/v1/questions", params: { format: :json, question: attributes_for(:invalid_question), access_token: access_token }
          expect(response.status).to eq 422
        end

        it 'saves the new question in database' do
          expect { post "/api/v1/questions", params: {
              format: :json, question: attributes_for(:invalid_question), access_token: access_token }
          }.to_not change(Question, :count)
        end
      end

    end
  end
end
