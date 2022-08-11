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

module ResourceQuotable
  # Flag is true when the quota has been reached.
  class Quotum < ApplicationRecord
    belongs_to :user, class_name: ResourceQuotable.user_class.to_s
    has_many :quotum_limits, dependent: :destroy

    validates :resource_class, :action, presence: true

    enum action: ResourceQuotable.actions, _suffix: true

    def self.quotum_for(action, resource)
      find_by(action: action, resource_class: resource)
    end

    def increment!
      raise ResourceQuotable::QuotaLimitError if flag

      ActiveRecord::Base.transaction do
        quotum_limits.map(&:increment!)
        check_flag!
      end
    end

    def check_flag!
      self.flag = false
      quotum_limits.map { |limit| self.flag = flag || limit.flag }
      save
    end
  end
end
