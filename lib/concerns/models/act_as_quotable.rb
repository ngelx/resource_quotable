# frozen_string_literal: true

module ResourceQuotable
  module ActsAsQuotable # :nodoc:
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_quotable(_options = {})
        has_many :quota, dependent: :destroy, class_name: 'ResourceQuotable::Quotum', foreign_key: 'user_id'
      end
    end

    included do
      def allowed_to?(options = { action: nil, resource: nil })
        # We still need to do something with this.
        quota.quotum_for(options[:action], options[:resource])&.flag ? false : true
      end
    end
  end
end
