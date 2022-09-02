# frozen_string_literal: true

module ResourceQuotable
  module Reset
    # Reset Quota for all period.
    class All < Base
      include ActiveModel::Validations

      protected

      def quotum_in_period
        Quotum.all
      end
    end
  end
end
