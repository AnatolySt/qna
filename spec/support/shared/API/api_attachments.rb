shared_examples_for 'API Attachable' do
  context 'attachments' do
    it 'included in question object' do
      expect(response.body).to have_json_size(1).at_path('attachments')
    end

    it 'contains attachment url' do
      expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('attachments/0')
    end
  end
end