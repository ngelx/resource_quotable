# frozen_string_literal: true

module ResourceQuotable
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
