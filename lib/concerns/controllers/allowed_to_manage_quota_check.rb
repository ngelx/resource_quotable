# frozen_string_literal: true

module ResourceQuotable
  module AllowedToManageQuotaCheck # :nodoc:
    extend ActiveSupport::Concern

    included do
      def allowed_to_manage_quota?
        true
      end

      def resource_quotable_before; end
      def resource_quotable_after; end
    end
  end
end
