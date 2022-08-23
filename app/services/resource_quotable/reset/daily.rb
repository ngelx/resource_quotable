# frozen_string_literal: true

module ResourceQuotable
  module Reset
    class Daily < Base
      include ActiveModel::Validations

      protected

      def quotum_in_period
        QuotumLimit.daily_period
      end
    end
  end
end
