# frozen_string_literal: true

module ResourceQuotable
  module Reset
    class Weekly < Base
      include ActiveModel::Validations

      protected

      def quotum_in_period
        QuotumLimit.weekly_period
      end
    end
  end
end
