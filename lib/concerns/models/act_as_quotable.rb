# frozen_string_literal: true

module ResourceQuotable
  module ActsAsQuotable # :nodoc:
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_quotable(_options = {})
        has_many :quota, dependent: :destroy, class_name: 'ResourceQuotable::Quotum', foreign_key: 'group_id'

        define_method(:resource_quotable_users) { ActiveModel::Naming.plural(ResourceQuotable.user_class) }
      end
    end
  end
end
