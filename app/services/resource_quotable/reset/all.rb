# frozen_string_literal: true

module ResourceQuotable
  module Reset
    class All < Base
      include ActiveModel::Validations

      protected

      def quotum_in_period
        QuotumLimit.all
      end
    end
  end
end
