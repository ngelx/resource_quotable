# frozen_string_literal: true

module ResourceQuotable
  module QuotumTrackerServices
    # Reset a quotum_tracker instance.
    class Reset < ::ResourceQuotable::Base
      attr_accessor :quotum_tracker

      validates :quotum_tracker, presence: true

      def call
        quotum_tracker.reset!
        quotum_tracker.reload
      end
    end
  end
end
