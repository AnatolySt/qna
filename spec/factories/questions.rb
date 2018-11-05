FactoryBot.define do
  sequence :title_generate do |n|
    "MyString#{n}"
  end

  factory :question do
    title { "MyString" }
    body { "MyText" }
    user
  end

  factory :question_second, class: Question do
    title { "MyStringSecond" }
    body { "MyText" }
    user
  end

  factory :invalid_question, class: Question do
    title { nil }
    body { nil }
  end
end
