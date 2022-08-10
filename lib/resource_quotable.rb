# frozen_string_literal: true

require 'resource_quotable/version'
require 'resource_quotable/engine'
require 'resource_quotable/act_as_quotable'

module ResourceQuotable
  # Your code goes here...
  mattr_accessor :user_class

  def self.user_class
    @@user_class.constantize
  end
end

# Extend ActiveRecord::Base with paranoid associations
ActiveRecord::Base.include ResourceQuotable::ActsAsQuotable
