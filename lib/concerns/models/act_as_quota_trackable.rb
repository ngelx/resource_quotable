# frozen_string_literal: true

module ResourceQuotable
  module ActsAsQuotaTrackable # :nodoc:
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_quota_trackable(_options = {})
        has_many :quotum_trackers,
                 dependent: :destroy,
                 class_name: 'ResourceQuotable::QuotumTracker',
                 foreign_key: 'user_id',
                 inverse_of: :user

        define_method(:resource_quotable_group) { send(ResourceQuotable.group_method) }

        define_method(:quota_for_resource_action) do |resource, action|
          resource_quotable_group.quota.for_resource_action(resource, action)
        end
      end
    end
  end
end
