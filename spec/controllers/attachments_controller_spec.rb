require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:attachment) { create(:attachment, attachable: question) }
  let(:other_user) { create(:user) }
  let!(:ability) { Ability.new(user) }

  describe 'DELETE #destroy' do

    context 'author delete his attachment' do
      it 'deletes attachment' do
        sign_in(user)
        expect { delete :destroy, params: { id: attachment, user: user }, format: :js }.to change(question.attachments, :count).by(-1)
      end
    end

    context 'user trying to delete not his attachment' do
      it 'not deletes attachment' do
        sign_in(other_user)
        expect { delete :destroy, params: { id: attachment, question_id: question, format: :js } }.to_not change(question.attachments, :count)
      end
    end

  end
end