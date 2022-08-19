# frozen_string_literal: true

module ResourceQuotable
  class Create < Base
    attr_accessor :user_id, :action, :resource, :limit, :period

    validates :user_id, :resource, presence: true
    validates_inclusion_of :action, in: ResourceQuotable.actions.keys
    validates_inclusion_of :period, in: QuotumLimit.periods.keys.map(&:to_sym)
    validates_numericality_of :limit, only_integer: true, greater_than_or_equal_to: 0

    def call
      quotum = load_quotum
      quotum ||= user.quota.create(resource_class: resource, action: action, flag: limit.zero?)

      raise QuotaLimitDuplicateError if quotum.quotum_limits.find_by(period: period)

      quotum.quotum_limits.create(period: period, limit: limit, counter: 0, flag: limit.zero?)
    end
  end
end
