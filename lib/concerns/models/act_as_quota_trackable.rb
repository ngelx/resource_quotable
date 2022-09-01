# frozen_string_literal: true

module ResourceQuotable
  module ActsAsQuotable # :nodoc:
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_quota_trackable(_options = {})
        has_many :quotum_trackers,
                 dependent: :destroy,
                 class_name: 'ResourceQuotable::QuotumTracker',
                 foreign_key: 'user_id'
      end
    end

    included do
      def allowed_to?(options = { action: nil, resource: nil })
        # We still need to do something with this.
        # TODO: update this for group.
        quotum_trackers.quotum_for(options[:action], options[:resource])&.flag ? false : true
      end
    end
  end
end
