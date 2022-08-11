# frozen_string_literal: true

module ResourceQuotable
  class ApplicationRecord < ActiveRecord::Base # :nodoc:
    self.abstract_class = true
  end
end
