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

        define_method(:resource_quotable_group) { send(ActiveModel::Naming.param_key(ResourceQuotable.group_class)) }

        define_method(:quota_for_resource_action) do |resource, action|
          resource_quotable_group.quota.for_resource_action(resource, action)
        end
      end
    end

    # included do
    #   def allowed_to?(options = { action: nil, resource: nil })
    #     # We still need to do something with this.
    #     # TODO: update this for group.
    #     quotum_trackers.for(options[:action], options[:resource])&.flag ? false : true
    #   end
    # end
  end
end
