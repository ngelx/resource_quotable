# == Schema Information
#
# Table name: resource_bs
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :resource_b do
    name { FFaker::Internet.slug }
  end
end
