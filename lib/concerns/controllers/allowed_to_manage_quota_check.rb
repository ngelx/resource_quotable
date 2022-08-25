# frozen_string_literal: true

module ResourceQuotable
  module AllowedToManageQuotaCheck # :nodoc:
    extend ActiveSupport::Concern

    included do
      def allowed_to_manage_quota?
        true
      end
    end
  end
end
