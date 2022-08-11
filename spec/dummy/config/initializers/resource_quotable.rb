# frozen_string_literal: true

ResourceQuotable.user_class = 'AdminUser'

# Default [:create,:update, :destroy]
ResourceQuotable.actions = {
  create: 0,
  update: 1,
  destroy: 2,
  send: 3
}.freeze

# Resources
ResourceQuotable.resources = %w[ResourceA ResourceB NotModel]
