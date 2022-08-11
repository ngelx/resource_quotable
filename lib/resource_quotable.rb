# frozen_string_literal: true

require 'resource_quotable/version'
require 'resource_quotable/engine'
require 'resource_quotable/act_as_quotable'
require 'resource_quotable/exeptions'

module ResourceQuotable # :nodoc:
  mattr_accessor :user_class
  mattr_accessor :resources
  mattr_accessor :actions

  DEFAULT_ACTIONS = {
    create: 0,
    update: 1,
    destroy: 2
  }.freeze

  def self.user_class
    @@user_class.constantize
  end

  def self.resource
    @@resources
  end

  def self.actions
    @@actions.empty? ? DEFAULT_ACTIONS : @@actions
  end
end

# Extend ActiveRecord::Base with paranoid associations
ActiveRecord::Base.include ResourceQuotable::ActsAsQuotable
