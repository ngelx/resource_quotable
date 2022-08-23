# frozen_string_literal: true

module ResourceQuotable
  module Reset
    class Base < ResourceQuotable::Base
      include ActiveModel::Validations

      def call
        quotum_ids = []

        quotum_in_period.with_active_counter.each do |quotum_limit|
          flag = quotum_limit.flag

          quotum_limit.update(counter: 0, flag: false)

          quotum_ids.push(quotum_limit.quotum_id) if flag
        end

        Quotum.where(id: quotum_ids.uniq).each(&:check_flag!) unless quotum_ids.empty?
      end

      protected

      def quotum_in_period
        raise ResourceQuotable::AbstractClassError
      end
    end
  end
end
