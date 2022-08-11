# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResourceQuotable do
  include Shoulda::Matchers::ActiveModel

  it { expect(described_class.actions).to eq %i[create delete update send] }
  it { expect(described_class.resource).to eq %w[ResourceA ResourceB NotModel] }
end
