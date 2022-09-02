# frozen_string_literal: true

module ResourceQuotable
  module Reset
    # Base Reset Quota for X period.
    class Base < ResourceQuotable::Base
      include ActiveModel::Validations

      def call
        quotum_in_period.each do |quotum|
          quotum.quotum_trackers.with_active_counter.map(&:reset!)
        end
      end

      protected

      def quotum_in_period
        raise ResourceQuotable::AbstractClassError
      end
    end
  end
end
