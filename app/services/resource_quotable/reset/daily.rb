# frozen_string_literal: true

module ResourceQuotable
  module Reset
    # Reset Quota for daily period.
    class Daily < Base
      include ActiveModel::Validations

      protected

      def quotum_in_period
        Quotum.daily_period
      end
    end
  end
end
