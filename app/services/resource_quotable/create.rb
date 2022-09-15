# frozen_string_literal: true

module ResourceQuotable
  # Create Quota and all quota_trackers for a group of users.
  class Create < Base
    attr_accessor :group, :action, :resource, :limit, :period

    validates :group, :resource, presence: true
    validates_inclusion_of :action, in: ResourceQuotable.actions.keys
    validates_inclusion_of :period, in: Quotum.periods.keys.map(&:to_sym)
    validates_numericality_of :limit, only_integer: true, greater_than_or_equal_to: 0

    def call
      # Crear Quotum
      # Crear QuotaTracker user existentes.
      quotum = nil
      flag = !limit.positive?

      ResourceQuotable::Quotum.transaction do
        quotum = group.quota.create!(resource_class: resource, action: action, period: period, limit: limit)
        group.resource_quotable_users.map { |user| user.quotum_trackers.create!(quotum: quotum, counter: 0, flag: flag) }
      end

      quotum
    rescue ActiveRecord::RecordNotUnique
      raise ResourceQuotable::QuotaDuplicateError
    end
  end
end
