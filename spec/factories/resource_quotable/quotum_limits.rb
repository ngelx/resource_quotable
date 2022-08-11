# == Schema Information
#
# Table name: resource_quotable_quotum_limits
#
#  id        :integer          not null, primary key
#  counter   :integer          default(0), not null
#  flag      :boolean          default(FALSE), not null
#  limit     :integer          default(1), not null
#  period    :integer          default(0), not null
#  quotum_id :integer          not null
#
# Indexes
#
#  index_resource_quotable_quotum_limits_on_quotum_id  (quotum_id)
#

# frozen_string_literal: true

FactoryBot.define do
  factory :quotum_limit, class: 'ResourceQuotable::QuotumLimit' do
    quotum
    limit { 10 }
    period { :daily }
    flag { false }
    counter { 1 }
  end
end
