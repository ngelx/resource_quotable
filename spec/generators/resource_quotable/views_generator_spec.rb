# frozen_string_literal: true

require 'rails_helper'
require 'generator_spec'

module ResourceQuotable
  module Generators
    RSpec.describe ViewsGenerator, type: :generator do
      destination File.expand_path('../tmp', __dir__)

      before do
        prepare_destination
        run_generator
      end

      it 'creates a test initializer' do
        expect(destination_root).to have_structure {
          directory 'app' do
            directory 'views' do
              directory 'resource_quotable' do
                directory 'quota' do
                  file 'index.html.erb'
                end
              end
            end
          end
        }
        # assert_file "config/initializers/test.rb", "# Initializer"
      end
    end
  end
end
