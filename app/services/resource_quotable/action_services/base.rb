# frozen_string_literal: true

module ResourceQuotable
  module ActionServices
    # Check Resource#action Quota for a user.
    # return false if it is ok.
    # return true if it is blocked
    class Base < ResourceQuotable::Base
      attr_accessor :user, :action, :resource

      validates :user, :resource, presence: true
      validates_inclusion_of :action, in: ResourceQuotable.actions.keys

      protected

      def find_or_create_quotum_tracker(quotum)
        quotum_tracker = quotum.quotum_trackers.find_by(user: user)
        quotum_tracker ||= user.quotum_trackers.create!(quotum: quotum, counter: 0, flag: !quotum.limit.positive?)
        quotum_tracker
      end
    end
  end
end
