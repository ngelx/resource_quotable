# frozen_string_literal: true

require 'rails_helper'

module ResourceQuotable
  RSpec.describe Destroy do
    include Shoulda::Matchers::ActiveModel

    describe 'Basic' do
      it { is_expected.to be_kind_of(ResourceQuotable::Base) }

      it { is_expected.to validate_presence_of(:quotum) }
    end

    describe 'Call' do
      subject(:call) { described_class.call(quotum: quotum) }

      let(:quotum) { build_stubbed(:quotum) }

      before do
        allow(quotum).to receive(:destroy).and_return(true)
      end

      it { expect(call).to be true }

      it 'call destroy on quotum' do
        call
        expect(quotum).to have_received(:destroy)
      end
    end
  end
end
