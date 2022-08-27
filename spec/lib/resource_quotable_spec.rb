# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResourceQuotable do
  include Shoulda::Matchers::ActiveModel

  let(:actions) do
    {
      create: 0,
      update: 1,
      destroy: 2,
      send: 3
    }.freeze
  end

  it { expect(described_class.actions).to eq actions }
  it { expect(described_class.resources).to eq %w[ResourceA ResourceB NotModel] }
  it { expect(described_class.main_content).to eq 'resource_quotable_content' }
  it { expect(described_class.base_controller).to eq ::ApplicationController }
end
