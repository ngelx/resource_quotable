# frozen_string_literal: true

module ResourceQuotable
  module Reset
    class Yearly < Base
      include ActiveModel::Validations

      protected

      def quotum_in_period
        QuotumLimit.yearly_period
      end
    end
  end
end
