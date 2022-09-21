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

  ##
  # Mandatory settings
  #
  # Resources to track quota.
  #   format: Array of strings. Could be anything.
  #
  config.resources = %w[ResourceA ResourceB NotModel]

  ##
  # Optional settings

  # Method to access group form user instance.
  # default: 'group'
  config.group_method = 'user_group'

  # Method to access users form group instance.
  # default: 'users'
  config.users_method = 'admin_users'

  # main_content ID for rendering.
  # default: 'resource_quotable_content'
  config.main_content = 'resource_quotable_content'

  # Base controller.
  # default: '::ApplicationController'
  config.base_controller = '::ApplicationController'

  # Actions
  # Default [:create,:update, :destroy]
  config.actions = {
    create: 0,
    update: 1,
    destroy: 2,
    send: 3
  }.freeze

end
```

Attach Quotable to model.

```ruby
class User < ApplicationRecord
  acts_as_quota_trackable
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

```ruby
class SomeController < ApplicationController
  # ...

  def create
    allowed_to?('SomeResource', :create)
    # ...
    quota_increase('SomeResource', :create)
    # ...
  end

  # ...
end
```

## Customizations

Customize views

`rails g resource_quotable:views`

Customize Controllers

```ruby
class ApplicationController < ActionController::Base
  # ...

  def allowed_to?(resource, action)
    !ResourceQuotable::ActionServices::Check(user: current_user, resource: resource, action: action)
  end

  def allowed_to_manage_quota?
    # Customize if the current_user can access to the quota management interface
    true
  end
  # Customize How Quotum model are retrieve/filter. Useful for scopes
  # i.e Quotum.where(...)
  def quota_scoped
    Quotum
  end

  def resource_quotable_before
    # hook before every action
  end

  def resource_quotable_after
    # hook after every action
  end

  def load_quotable_group
    # Customize how to retrieve the group model
    # default: quotum_params[:group_type].constantize.find(quotum_params[:group_id])
    scooped_groups.find(params[:quotum][:group_id])
  end

  # ...
end
```

## API

Still Working on this doc....


## Contributing

```bash
$ docker-sync start
$ docker-compose build
$ docker-compose run web bundle install
$ docker-compose run web bundle rails db:setup
$ docker-compose run web bundle rspec
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
