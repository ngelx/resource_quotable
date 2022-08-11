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

# frozen_string_literal: true

FactoryBot.define do
  factory :quotum, class: 'ResourceQuotable::Quotum' do
    association :user, factory: :admin_user

    resource_class { 'ResourceA' }
    action { :create }
    flag { false }
  end
end
