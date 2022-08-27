# frozen_string_literal: true

ResourceQuotable.setup do |config|
  config.user_class = 'AdminUser'
  # main_content ID for rendering. default: 'resource_quotable_content'
  config.main_content = 'resource_quotable_content'

  config.base_controller = '::ApplicationController'

  # Default [:create,:update, :destroy]
  config.actions = {
    create: 0,
    update: 1,
    destroy: 2,
    send: 3
  }.freeze

  # Resources
  config.resources = %w[ResourceA ResourceB NotModel]
end
