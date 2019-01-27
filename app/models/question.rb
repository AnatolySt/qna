class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank

  scope :digest, -> { where("created_at > ?", 1.day.ago) }
end
