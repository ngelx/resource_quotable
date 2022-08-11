# frozen_string_literal: true

require_relative 'lib/resource_quotable/version'

Gem::Specification.new do |spec|
  spec.name        = 'resource_quotable'
  spec.version     = ResourceQuotable::VERSION
  spec.authors     = ['Ngel']
  spec.email       = ['ngel@protonmail.com']
  spec.homepage    = 'https://bitbucket.org/angel_arancibia/resource_quotable/src/master/'
  spec.summary     = 'Quota system for resource'
  spec.description = 'Quota system for resource.'
  spec.license     = 'MIT'
  spec.required_ruby_version = '>= 2.7'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/CHANGELOG.md"

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'Readme.md', 'Changelog.md']

  spec.add_dependency 'rails', '~> 6.1.4', '>= 6.1.4.7'

  spec.add_development_dependency 'annotate'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'ffaker'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rails'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'shoulda-matchers'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
