# frozen_string_literal: true

require 'rails_helper'

module ResourceQuotable
  RSpec.describe Base do
    include Shoulda::Matchers::ActiveModel

    describe 'Basic' do
      it { expect { described_class.call }.to raise_error(ResourceQuotable::AbstractClassError) }
    end
  end
end
