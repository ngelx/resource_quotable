# frozen_string_literal: true

module ResourceQuotable
  module ActsAsQuotable # :nodoc:
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_quotable(_options = {})
        has_many :quota, dependent: :destroy, class_name: 'ResourceQuotable::Quotum', foreign_key: 'group_id'
      end
    end
  end
end
