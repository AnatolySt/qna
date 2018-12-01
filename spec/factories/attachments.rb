FactoryBot.define do

  factory :attachment do
    file do
      Rails.root.join('spec/rails_helper.rb').open
    end
  end

end
