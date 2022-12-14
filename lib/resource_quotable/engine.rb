# frozen_string_literal: true

module ResourceQuotable
  class Engine < ::Rails::Engine  # :nodoc:
    isolate_namespace ResourceQuotable

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
    end
  end
end
