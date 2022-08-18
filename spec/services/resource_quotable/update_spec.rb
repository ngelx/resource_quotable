# frozen_string_literal: true

require 'rails_helper'

module ResourceQuotable
  RSpec.describe Update do
    include Shoulda::Matchers::ActiveModel

    describe 'Basic' do
      it { is_expected.to be_kind_of(ResourceQuotable::Base) }

      it { is_expected.to validate_presence_of(:quotum_limit) }
      it { is_expected.to validate_numericality_of(:limit).only_integer.is_greater_than_or_equal_to(0) }
    end

    describe 'Call' do
      subject(:call) { described_class.call(quotum_limit: quotum_limit, limit: new_limit) }

      let(:quotum) { build_stubbed(:quotum) }

      before { allow(quotum).to receive(:check_flag!) }

      describe 'flag true, new flag true' do
        let(:quotum_limit) { create(:quotum_limit, quotum: quotum, flag: true, counter: 10, limit: 10) }

        let(:new_limit) { 8 }

        before { quotum_limit }

        it { expect { call }.not_to change(QuotumLimit, :count) }

        it { expect(call).to be_kind_of(QuotumLimit) }
        it { expect(call.limit).to eq 8 }
        it { expect(call.flag).to be true }

        it 'not call check_flag on quotum' do
          call
          expect(quotum).not_to have_received(:check_flag!)
        end
      end

      describe 'flag true, new flag false' do
        let(:quotum_limit) { create(:quotum_limit, quotum: quotum, flag: true, counter: 10, limit: 10) }

        let(:new_limit) { 12 }

        before { quotum_limit }

        it { expect { call }.not_to change(QuotumLimit, :count) }

        it { expect(call).to be_kind_of(QuotumLimit) }
        it { expect(call.limit).to eq 12 }
        it { expect(call.flag).to be false }

        it 'call check_flag on quotum' do
          call
          expect(quotum).to have_received(:check_flag!)
        end
      end

      describe 'flag false, new flag false' do
        let(:quotum_limit) { create(:quotum_limit, quotum: quotum, flag: false, counter: 8, limit: 10) }

        let(:new_limit) { 12 }

        before { quotum_limit }

        it { expect { call }.not_to change(QuotumLimit, :count) }

        it { expect(call).to be_kind_of(QuotumLimit) }
        it { expect(call.limit).to eq 12 }
        it { expect(call.flag).to be false }

        it 'not call check_flag on quotum' do
          call
          expect(quotum).not_to have_received(:check_flag!)
        end
      end

      describe 'flag false, new flag true' do
        let(:quotum_limit) { create(:quotum_limit, quotum: quotum, flag: false, counter: 8, limit: 10) }

        let(:new_limit) { 8 }

        before { quotum_limit }

        it { expect { call }.not_to change(QuotumLimit, :count) }

        it { expect(call).to be_kind_of(QuotumLimit) }
        it { expect(call.limit).to eq 8 }
        it { expect(call.flag).to be true }

        it 'call check_flag on quotum' do
          call
          expect(quotum).to have_received(:check_flag!)
        end
      end
    end
  end
end
