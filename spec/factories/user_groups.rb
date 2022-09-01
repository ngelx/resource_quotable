FactoryBot.define do
  factory :user_group do
    name { FFaker::Internet.user_name }
  end
end
