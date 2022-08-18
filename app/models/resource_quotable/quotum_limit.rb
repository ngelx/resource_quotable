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

module ResourceQuotable
  # Flag is true when the quota has been reached.
  class QuotumLimit < ApplicationRecord
    belongs_to :quotum

    validates :counter, :limit, :period, presence: true

    enum period: {
      any: 0,
      daily: 1,
      weekly: 2,
      monthly: 3,
      yearly: 4
    }, _suffix: true

    delegate :user, to: :quotum

    def increment!
      raise ResourceQuotable::QuotaLimitError if flag

      self.counter += 1
      self.flag = (counter >= limit)
      save
    end

    def reset!
      return if counter.zero?

      self.counter = 0
      self.flag = (counter >= limit)
      save

      # I don't like this here.
      quotum.check_flag!
    end
  end
end
