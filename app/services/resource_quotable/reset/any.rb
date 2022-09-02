# frozen_string_literal: true

module ResourceQuotable
  module Reset
    # Reset Quota for Any period.
    class Any < Base
      include ActiveModel::Validations

      protected

      def quotum_in_period
        Quotum.any_period
      end
    end
  end
end
