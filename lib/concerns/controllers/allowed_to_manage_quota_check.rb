# frozen_string_literal: true

module ResourceQuotable
  # API inclusion to ApplicationController in order to allow customizations.
  #
  module AllowedToManageQuotaCheck
    extend ActiveSupport::Concern

    included do
      helper_method :allowed_to?

      def allowed_to?(action, resource)
        !ResourceQuotable::ActionServices::Check.call(
          user: load_quotable_tracker_user,
          resource: resource,
          action: action
        )
      end

      def allowed_to_do_multi?(action, resource, amount)
        !ResourceQuotable::ActionServices::CheckMultiple.call(
          user: load_quotable_tracker_user,
          resource: resource,
          action: action,
          amount: amount
        )
      end

      def quota_authorize!(action, resource)
        raise ResourceQuotable::QuotaLimitError unless allowed_to?(action, resource)
      end

      def quota_authorize_multiple!(action, resource, amount)
        raise ResourceQuotable::QuotaMultiLimitError unless allowed_to_do_multi?(action, resource, amount)
      end

      def quota_increment!(action, resource)
        quota_authorize!(action, resource)
        ResourceQuotable::ActionServices::Increment.call(
          user: load_quotable_tracker_user,
          resource: resource,
          action: action
        )
      end

      def quota_increment_multiple!(action, resource, amount)
        quota_authorize_multiple!(action, resource, amount)
        ResourceQuotable::ActionServices::IncrementMultiple.call(
          user: load_quotable_tracker_user,
          resource: resource,
          action: action,
          amount: amount
        )
      end

      def allowed_to_manage_quota?
        true
      end

      def quota_scoped
        Quotum
      end

      def load_quotable_tracker_user
        current_user
      end

      def load_quotable_group; end
      def resource_quotable_before; end
      def resource_quotable_after; end
    end
  end
end
