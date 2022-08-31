# frozen_string_literal: true

require 'rails/generators'

module ResourceQuotable
  module Generators
    class ViewsGenerator < Rails::Generators::Base # :nodoc:
      desc 'Create ResourceQuotable views template in your app/views folder.'

      source_root File.expand_path('../../../app/views', __dir__)
      # check_class_collision suffix: 'resource_quotable'

      def create_views
        directory 'resource_quotable', 'app/views/resource_quotable'
      end
    end
  end
end
