# == Schema Information
#
# Table name: resource_quotable_quota
#
#  id             :integer          not null, primary key
#  action         :integer
#  flag           :boolean
#  resource_class :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer          not null
#
# Indexes
#
#  index_resource_quotable_quota_on_user_id  (user_id)
#

FactoryBot.define do
  factory :quotum do
    association :user, factory: :admin_user

    resource_class { 'ResourceA' }
    action { 1 }
    flag { false }
  end
end
