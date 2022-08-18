# frozen_string_literal: true

module ResourceQuotable
  class QuotaLimitError < StandardError; end
  class QuotaLimitDuplicateError < StandardError; end
end
