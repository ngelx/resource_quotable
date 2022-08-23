# frozen_string_literal: true

module ResourceQuotable
  module Reset
    class Monthly < Base
      include ActiveModel::Validations

      protected

      def quotum_in_period
        QuotumLimit.monthly_period
      end
    end
  end
end
