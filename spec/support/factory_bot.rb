require 'ffaker'
require 'factory_bot_rails'

FactoryBot.definition_file_paths = [File.expand_path('../factories', __dir__)]
begin
  unless FactoryBot.factories.instance_variable_get(:@items)&.any?
    FactoryBot.find_definitions
  end
rescue StandardError => e
  warn "FactoryBot failed to load definitions: #{e.class}: #{e.message}"
  warn e.backtrace.join("\n")
  raise
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
