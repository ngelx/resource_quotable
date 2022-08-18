# frozen_string_literal: true

module ResourceQuotable
  class Destroy < Base
    include ActiveModel::Validations

    attr_accessor :quotum_limit

    validates :quotum_limit, presence: true

    def call
      flag = quotum_limit.flag
      quotum_id = quotum_limit.quotum_id

      quotum_limit.destroy

      Quotum.find(quotum_id).check_flag! if flag

      # TODO: remove Quotum when there is no more limits.

      true
    end
  end
end
