# frozen_string_literal: true

module ResourceQuotable
  module ActionServices
    # Check Resource#action Quota for a user.
    # return false if it is ok.
    # return true if it is blocked
    class Check < Base
      def call
        user.quota_for_resource_action(resource, action).each do |quotum|
          quotum_tracker = find_or_create_quotum_tracker(quotum)

          return true if quotum_tracker.flag?
        end
        false
      end
    end
  end
end
