# ResourceQuotable
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'resource_quotable'
```

And then execute:
```bash
$ bundle install
```

Install migrations:
```bash
$ rails resource_quotable:install:migrations
$ rails db:migrate
```

Mount engine:
```ruby
# config/routes.rb
Rails.application.routes.draw do
  # ...
  mount ResourceQuotable::Engine => '/resource_quotable'
  # ...
end

```

Configure:
```ruby
# config/initializers/resource_quotable.rb

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

# main_content ID for rendering. default: 'resource_quotable_content'
ResourceQuotable.main_content = 'resource_quotable_content'

```

## Contributing

`docker-sync start`
`docker-compose build`
`docker-compose run web bundle install`
`docker-compose run web bundle rspec`

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
