FactoryBot.define do

  factory :attachment do
    attachable { nil }
    file { Rails.root.join('spec/rails_helper.rb').open }
  end

end
