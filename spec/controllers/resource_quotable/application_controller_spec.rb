# frozen_string_literal: true

require 'rails_helper'

module ResourceQuotable
  RSpec.describe ApplicationController do
    subject(:application_controller) { described_class.new }

    it { expect(application_controller).to be_kind_of(ResourceQuotable.base_controller) }
  end
end
