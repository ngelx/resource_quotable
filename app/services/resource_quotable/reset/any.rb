# frozen_string_literal: true

module ResourceQuotable
  module Reset
    class Any < Base
      include ActiveModel::Validations

      protected

      def quotum_in_period
        QuotumLimit.any_period
      end
    end
  end
end
