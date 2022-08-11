# == Schema Information
#
# Table name: resource_as
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# frozen_string_literal: true

FactoryBot.define do
  factory :resource_a do
    name { FFaker::Internet.slug }
  end
end
