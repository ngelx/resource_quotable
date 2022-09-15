# ResourceQuotable
A Rails quota limit gem for resources. UNDER DEVELOPMENT

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

ResourceQuotable.setup do |config|
  config.group_class = 'UserGroup'

  config.user_class = 'User'
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
```

Attach Quotable to model.

```ruby
class User < ApplicationRecord
  acts_as_quotum_trackable
  # ....
  belongs_to :group
  # ....
end

class Group < ApplicationRecord
  acts_as_quotable
  # ....
  has_many :users, dependent: :destroy
  # ....
end
```

## Usage
Still Working on this doc....

## Contributing

```bash
$ docker-sync start
$ docker-compose build
$ docker-compose run web bundle install
$ docker-compose run web bundle rspec
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
