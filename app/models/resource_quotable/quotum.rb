# == Schema Information
#
# Table name: resource_quotable_quota
#
#  id             :integer          not null, primary key
#  action         :integer          default("create"), not null
#  group_type     :string           not null
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

module ResourceQuotable
  class Quotum < ApplicationRecord # :nodoc:
    belongs_to :group, polymorphic: true, inverse_of: :quota
    has_many :quotum_trackers, dependent: :destroy

    scope :for_resource_action, ->(resource, action) { where(action: action, resource_class: resource) }

    validates :resource_class, :action, :period, :limit, presence: true

    enum :action, ResourceQuotable.actions, suffix: true

    enum :period, {
      any: 0,
      daily: 1,
      weekly: 2,
      monthly: 3,
      yearly: 4
    }, suffix: true

    def to_s
      "#{period.to_s.capitalize} #{action} #{resource_class}."
    end
  end
end
