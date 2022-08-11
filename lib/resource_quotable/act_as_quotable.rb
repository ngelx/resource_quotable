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
      def quota_for?(_options = { action: nil, resource: nil })
        # We still need to do something with this.
        true
      end
    end
  end
end
