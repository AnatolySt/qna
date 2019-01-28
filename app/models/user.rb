class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:vkontakte, :github]

  has_many :answers
  has_many :questions
  has_many :votes, dependent: :destroy
  has_many :authorizations
  has_many :subscriptions

  after_create :new_answer_notification

  def author_of?(resource)
    resource.user_id == id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]

    while email.nil?
      generated_email = "#{SecureRandom.base58(10)}@qna.dev"
      if User.where(email: generated_email).blank?
        email = generated_email
      end
    end

    user = User.where(email: email).first
    if user
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    else
      password = Devise.friendly_token[0, 12]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    end
    user
  end

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.digest(user).deliver_now
    end
  end

  def new_answer_notification
    NewAnswerNotificationJob.perform_later(self)
  end

  def subscribed_for?(question)
    subscriptions.each { |s| return s if s.question == question }
    false
  end

end
