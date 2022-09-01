# == Schema Information
#
# Table name: resource_quotable_quotum_trackers
#
#  id        :integer          not null, primary key
#  counter   :integer          default(0), not null
#  flag      :boolean          default(FALSE), not null
#  quotum_id :integer          not null
#  user_id   :integer          not null
#
# Indexes
#
#  index_resource_quotable_quotum_trackers_on_quotum_id  (quotum_id)
#  index_resource_quotable_quotum_trackers_on_user_id    (user_id)
#  resource_quotable_quotum_trackers_unique_index        (user_id,quotum_id) UNIQUE
#

# frozen_string_literal: true

FactoryBot.define do
  factory :quotum_tracker, class: 'ResourceQuotable::QuotumTracker' do
    quotum
    association :user, factory: :admin_user
    flag { false }
    counter { 1 }
  end
end
