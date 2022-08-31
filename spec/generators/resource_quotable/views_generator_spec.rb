require 'rails_helper'

require 'generator_spec'
# require 'generators/smashing_documentation/install_generator'
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
                directory 'quotum_limits' do
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
