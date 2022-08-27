# frozen_string_literal: true

require 'resource_quotable/version'
require 'resource_quotable/engine'
require 'resource_quotable/exeptions'
require 'concerns/models/act_as_quotable'
require 'concerns/controllers/allowed_to_manage_quota_check'

require 'kaminari'

module ResourceQuotable # :nodoc:
  mattr_accessor :user_class
  mattr_accessor :resources
  mattr_accessor :actions
  mattr_accessor :main_content
  mattr_accessor :base_controller

  DEFAULT_ACTIONS = {
    create: 0,
    update: 1,
    destroy: 2
  }.freeze

  def self.user_class
    @@user_class.constantize
  end

  def self.resources
    @@resources
  end

  def self.actions
    @@actions.empty? ? DEFAULT_ACTIONS : @@actions
  end

  def self.main_content
    @@main_content.empty? ? 'resource_quotable_content' : @@main_content
  end

  def self.base_controller
    @@base_controller.constantize
  end

  # Default way to set up ResourceQuotable. Run rails generate resource_quotable_install to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end
end

# Extend ActiveRecord::Base with paranoid associations
ActiveRecord::Base.include ResourceQuotable::ActsAsQuotable
ActionController::Base.include ResourceQuotable::AllowedToManageQuotaCheck
