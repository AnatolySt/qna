FactoryBot.define do
  factory :answer do
    body { "MyText" }
    association :question
  end

  factory :invalid_answer, class: Question do
    body { nil }
  end
end
