# == Schema Information
#
# Table name: resource_quotable_quota
#
#  id             :integer          not null, primary key
#  action         :integer          default("create"), not null
#  limit          :integer          default(1), not null
#  period         :integer          default("any"), not null
#  resource_class :string           not null
#  created_at     :datetime
#  updated_at     :datetime
#  group_id       :integer          not null
#
# Indexes
#
#  index_resource_quotable_quota_on_group_id  (group_id)
#  resource_quotable_quota_unique_index       (group_id,resource_class,action,period) UNIQUE
#

# frozen_string_literal: true

FactoryBot.define do
  factory :quotum, class: 'ResourceQuotable::Quotum' do
    association :group, factory: :user_group
    resource_class { 'ResourceA' }
    action { :create }
    limit { 10 }
    period { :daily }
  end
end
