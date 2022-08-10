# == Schema Information
#
# Table name: admin_users
#
#  id         :integer          not null, primary key
#  username   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :admin_user do
    username { FFaker::Internet.user_name }
  end
end
