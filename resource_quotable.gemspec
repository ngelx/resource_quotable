# frozen_string_literal: true

require_relative 'lib/resource_quotable/version'

Gem::Specification.new do |spec|
  spec.name        = 'resource_quotable'
  spec.version     = ResourceQuotable::VERSION
  spec.authors     = ['Ngel']
  spec.email       = ['ngel@protonmail.com']
  spec.homepage    = 'https://bitbucket.org/angel_arancibia/resource_quotable/src/master/'
  spec.summary     = 'Quota system for resource'
  spec.description = 'Flexible quota system for resources.'
  spec.license     = 'MIT'
  spec.required_ruby_version = '>= 2.7'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/CHANGELOG.md"
  spec.post_install_message = <<~MESSAGE
    Please see https://bitbucket.org/angel_arancibia/resource_quotable/src/master/Changelog.md for details on how to finish the setup.
  MESSAGE

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'Readme.md', 'Changelog.md']

  spec.add_dependency 'kaminari', '~> 1.0', '>= 1.0.1'
  spec.add_dependency 'rails', '>= 4.2', '< 7'

  spec.add_development_dependency 'annotate', '~> 3.2'
  spec.add_development_dependency 'database_cleaner-active_record', '~> 2.0'
  spec.add_development_dependency 'factory_bot_rails', '~> 6.2'
  spec.add_development_dependency 'ffaker', '~> 2.21'
  spec.add_development_dependency 'generator_spec', '~> 0.9'
  spec.add_development_dependency 'rails-controller-testing', '~> 1.0'
  spec.add_development_dependency 'rspec-rails', '~> 5.1'
  spec.add_development_dependency 'rubocop', '~> 1.33'
  spec.add_development_dependency 'rubocop-rails', '~> 2.15'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.12'
  spec.add_development_dependency 'shoulda-matchers', '~> 5.1'
  spec.add_development_dependency 'simplecov', '~> 0.21'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
