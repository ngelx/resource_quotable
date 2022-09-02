# frozen_string_literal: true

require 'rails_helper'

module ResourceQuotable
  RSpec.describe Update do
    include Shoulda::Matchers::ActiveModel

    describe 'Basic' do
      it { is_expected.to be_kind_of(ResourceQuotable::Base) }

      it { is_expected.to validate_presence_of(:quotum) }
      it { is_expected.to validate_numericality_of(:limit).only_integer.is_greater_than_or_equal_to(0) }
    end

    describe 'Call' do
      subject(:call) { described_class.call(quotum: quotum, limit: new_limit) }

      let(:quotum) { create(:quotum, limit: 10) }
      let(:tracker7) { create(:quotum_tracker, quotum: quotum, counter: 7, flag: false) }
      let(:tracker8) { create(:quotum_tracker, quotum: quotum, counter: 8, flag: false) }
      let(:tracker8_noice) { create(:quotum_tracker, counter: 8, flag: false) }
      let(:tracker10) { create(:quotum_tracker, quotum: quotum, counter: 10, flag: true) }
      let(:tracker11) { create(:quotum_tracker, quotum: quotum, counter: 11, flag: true) }
      let(:tracker11_noice) { create(:quotum_tracker, counter: 11, flag: true) }
      let(:tracker12) { create(:quotum_tracker, quotum: quotum, counter: 12, flag: true) }

      before do
        tracker7
        tracker8
        tracker8_noice
        tracker10
        tracker11
        tracker11_noice
        tracker12
      end

      describe 'increase limit' do
        let(:new_limit) { 12 }

        it { expect { call }.not_to change(Quotum, :count) }
        it { expect(call).to be_kind_of(Quotum) }
        it { expect(call.limit).to eq 12 }

        it { expect { call }.not_to change { tracker7.reload.flag }.from(false) }
        it { expect { call }.not_to change { tracker8.reload.flag }.from(false) }
        it { expect { call }.not_to change { tracker8_noice.reload.flag }.from(false) }
        it { expect { call }.to change { tracker10.reload.flag }.from(true).to(false) }
        it { expect { call }.to change { tracker11.reload.flag }.from(true).to(false) }
        it { expect { call }.not_to change { tracker11_noice.reload.flag }.from(true) }
        it { expect { call }.not_to change { tracker12.reload.flag }.from(true) }
      end

      describe 'decrease limit' do
        let(:new_limit) { 8 }

        it { expect { call }.not_to change(Quotum, :count) }
        it { expect(call).to be_kind_of(Quotum) }
        it { expect(call.limit).to eq 8 }

        it { expect { call }.not_to change { tracker7.reload.flag }.from(false) }
        it { expect { call }.to change { tracker8.reload.flag }.from(false).to(true) }
        it { expect { call }.not_to change { tracker8_noice.reload.flag }.from(false) }
        it { expect { call }.not_to change { tracker10.reload.flag }.from(true) }
        it { expect { call }.not_to change { tracker11.reload.flag }.from(true) }
        it { expect { call }.not_to change { tracker11_noice.reload.flag }.from(true) }
        it { expect { call }.not_to change { tracker12.reload.flag }.from(true) }
      end
    end
  end
end
