# frozen_string_literal: true

module ResourceQuotable
  class Update < Base
    include ActiveModel::Validations

    attr_accessor :quotum_limit, :limit

    validates :quotum_limit, presence: true
    validates_numericality_of :limit, only_integer: true, greater_than_or_equal_to: 0

    def call
      flag = quotum_limit.flag
      new_flag = limit <= quotum_limit.counter

      quotum_limit.update(limit: limit, flag: new_flag)

      quotum_limit.quotum.check_flag! if flag != new_flag

      quotum_limit
    end
  end
end
