require 'rails_helper'

include Shoulda::Matchers::ActiveModel

RSpec.describe ResourceQuotable do
  it { expect(described_class.actions).to eq %i[create delete update send] }
  it { expect(described_class.resource).to eq %w[ResourceA ResourceB NotModel] }
end
