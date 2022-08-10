# frozen_string_literal: true

require 'resource_quotable/version'
require 'resource_quotable/engine'

module ResourceQuotable
  # Your code goes here...
  mattr_accessor :user_class

  def self.user_class
    @@user_class.constantize
  end
end
