# frozen_string_literal: true

module ResourceQuotable
  module Reset
    # Reset Quota for Yearly period.
    class Yearly < Base
      include ActiveModel::Validations

      protected

      def quotum_in_period
        Quotum.yearly_period
      end
    end
  end
end
