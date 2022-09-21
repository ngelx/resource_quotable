# frozen_string_literal: true

module ResourceQuotable
  module AllowedToManageQuotaCheck # :nodoc:
    extend ActiveSupport::Concern

    included do
      def allowed_to?(resource, action)
        !ResourceQuotable::ActionServices::Check(user: current_user, resource: resource, action: action)
      end

      def allowed_to_manage_quota?
        true
      end

      def quota_scoped
        Quota
      end

      def resource_quotable_before; end
      def resource_quotable_after; end

      def load_quotable_group; end
    end
  end
end
