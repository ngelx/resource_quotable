# frozen_string_literal: true

module ResourceQuotable
  module ActsAsQuotaTrackable # :nodoc:
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_quota_trackable(_options = {})
        has_many :quotum_trackers,
                 dependent: :destroy,
                 class_name: 'ResourceQuotable::QuotumTracker',
                 foreign_key: 'user_id'

        define_method(:resource_quotable_group) { ActiveModel::Naming.param_key(ResourceQuotable.group_class) }
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
