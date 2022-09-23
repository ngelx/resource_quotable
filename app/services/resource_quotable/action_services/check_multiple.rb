# frozen_string_literal: true

module ResourceQuotable
  module ActionServices
    # Check Resource#action Quota for a user.
    # return false if it is ok.
    # return true if it is blocked
    class CheckMultiple < Base
      attr_accessor :amount

      validates :amount, presence: true

      def call
        user.quota_for_resource_action(resource, action).each do |quotum|
          quotum_tracker = find_or_create_quotum_tracker(quotum)

          return true if quotum_tracker.counter + amount > quotu.limit
        end
        false
      end
    end
  end
end
