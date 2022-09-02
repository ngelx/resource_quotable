# frozen_string_literal: true

module ResourceQuotable
  # Update Quota and reset QuotumTracker flag according
  class Update < Base
    attr_accessor :quotum, :limit

    validates :quotum, presence: true
    validates_numericality_of :limit, only_integer: true, greater_than_or_equal_to: 0

    def call
      quotum.update(limit: limit)

      # rubocop:disable Rails/SkipsModelValidations
      # We know what we are doing. Validation and callback are not needed here.
      quotum.quotum_trackers.under_limit(limit).flagged.update_all(flag: false)
      quotum.quotum_trackers.over_limit(limit).not_flagged.update_all(flag: true)
      # rubocop:enable Rails/SkipsModelValidations

      quotum
    end
  end
end
