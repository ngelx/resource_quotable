# frozen_string_literal: true

module ResourceQuotable
  class QuotaLimitError < StandardError; end
  class QuotaMulitLimitError < StandardError; end
  class QuotaDuplicateError < StandardError; end
  class AbstractClassError < StandardError; end
  class AuthorizationError < StandardError; end
end
