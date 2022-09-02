# frozen_string_literal: true

module ResourceQuotable
  module Reset
    # Reset Quota for Monthly period.
    class Monthly < Base
      include ActiveModel::Validations

      protected

      def quotum_in_period
        Quotum.monthly_period
      end
    end
  end
end
