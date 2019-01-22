class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :best, :user_id, :attachments, :question_id

  has_many :comments

  def attachments
    object.attachments.map { |a| a.file.url }
  end
end
