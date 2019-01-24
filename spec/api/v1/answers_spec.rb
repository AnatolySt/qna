require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    let(:question) { create(:question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token).token }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token } }

      it 'returns 200 status code' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2)
      end

      %w(id body created_at updated_at best user_id).each do |attr|
        it "returns #{attr} field" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let(:answer) { create(:answer) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token).token }
      let(:answer) { create(:answer) }
      let!(:attachment) { create(:attachment, attachable: answer) }
      let!(:comment) { create(:question_comment, commentable: answer) }

      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token } }

      it 'returns 200 status code' do
        expect(response).to be_successful
      end

      %w(id body created_at updated_at best user_id).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path('attachments')
        end

        it 'contains attachment url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('attachments/0')
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('comments')
        end

        %w(id body commentable_type commentable_id user_id created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

    end
  end



  describe 'POST /create' do
    let(:question) { create(:question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: attributes_for(:answer) }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: attributes_for(:answer) }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token).token }

      context 'answer with valid attributes' do
        it 'returns 200 status code' do
          post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: attributes_for(:answer), access_token: access_token }
          expect(response).to be_successful
        end

        it 'saves the new question in database' do
          expect { post "/api/v1/questions/#{question.id}/answers", params: {
              format: :json, answer: attributes_for(:answer), access_token: access_token }
          }.to change(Answer, :count).by(1)
        end
      end


      context 'with invalid attributes' do
        it 'returns 422 status code' do
          post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: attributes_for(:invalid_answer), access_token: access_token }
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