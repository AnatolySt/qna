FactoryBot.define do

  sequence :body do |n|
    "MyAnswerText #{n}"
  end

  factory :answer do
    body
    question
    user
  end

  factory :invalid_answer, class: Question do
    body { nil }
  end
end
