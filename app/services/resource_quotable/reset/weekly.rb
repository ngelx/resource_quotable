# frozen_string_literal: true

module ResourceQuotable
  module Reset
    # Reset Quota for Weekly period.
    class Weekly < Base
      include ActiveModel::Validations

      protected

      def quotum_in_period
        Quotum.weekly_period
      end
    end
  end
end
