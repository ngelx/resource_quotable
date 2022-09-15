# frozen_string_literal: true

module ResourceQuotable
  module ActionServices
    # Increment Resource#action Quota counter for a user.
    class Increment < Base
      def call
        ResourceQuotable::Quotum.transaction do
          user.quota_for_resource_action(resource, action).each do |quotum|
            quotum_tracker = find_or_create_quotum_tracker(quotum)

            quotum_tracker.increment!
          end
        end
      end
    end
  end
end
