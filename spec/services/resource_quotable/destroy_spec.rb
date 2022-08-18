# frozen_string_literal: true

require 'rails_helper'

module ResourceQuotable
  RSpec.describe Destroy do
    include Shoulda::Matchers::ActiveModel

    describe 'Basic' do
      it { is_expected.to be_kind_of(ResourceQuotable::Base) }

      it { is_expected.to validate_presence_of(:quotum_limit) }
    end

    describe 'Call' do
      subject(:call) { described_class.call(quotum_limit: quotum_limit) }

      let(:quotum) { build_stubbed(:quotum) }

      before do
        allow(quotum).to receive(:check_flag!)
        allow(Quotum).to receive(:find).with(quotum.id).and_return(quotum)
      end

      describe 'flag true' do
        let(:quotum_limit) { create(:quotum_limit, quotum: quotum, flag: true) }

        before { quotum_limit }

        it { expect(call).to be true }

        it { expect { call }.to change(QuotumLimit, :count).by(-1) }

        it 'call check_flag on quotum' do
          call
          expect(quotum).to have_received(:check_flag!)
        end
      end

      describe 'flag false' do
        let(:quotum_limit) { create(:quotum_limit, quotum: quotum, flag: false) }

        before { quotum_limit }

        it { expect(call).to be true }

        it { expect { call }.to change(QuotumLimit, :count).by(-1) }

        it 'not to call check_flag on quotum' do
          call
          expect(quotum).not_to have_received(:check_flag!)
        end
      end
    end
  end
end
