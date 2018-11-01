FactoryBot.define do
  factory :answer do
    body { "MyAnswerText" }
    question
    user
  end

  factory :invalid_answer, class: Question do
    body { nil }
  end
end
