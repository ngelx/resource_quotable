# frozen_string_literal: true

require 'rails_helper'

module ResourceQuotable
  RSpec.describe Reset::Base do
    include Shoulda::Matchers::ActiveModel

    describe 'Basic' do
      it { is_expected.to be_kind_of(ResourceQuotable::Base) }
    end

    describe 'call' do
      subject(:call) { described_class.call }

      let(:quotums) { create_list(:quotum, 3) }
      let(:quotum1) { quotums.first }
      let(:quotum2) { quotums.second }
      let(:quotum3) { quotums.last }
      let(:limits_to_reset1) { create_list(:quotum_limit, 2, counter: 10, quotum: quotum1, flag: true) }
      let(:limits_to_reset2) { create_list(:quotum_limit, 2, counter: 10, quotum: quotum2, flag: false) }
      let(:limits_not_to_reset) { create_list(:quotum_limit, 2, counter: 0, flag: true) }
      let(:weekly_limits) { create_list(:quotum_limit, 2, period: :weekly, counter: 10, limit: 10, flag: true) }
      let(:limits_ids) { limits_to_reset1.pluck(:id) + limits_to_reset2.pluck(:id) + limits_not_to_reset.pluck(:id) }

      before do
        limits_to_reset1
        limits_to_reset2
        limits_not_to_reset
        weekly_limits
      end

      it { expect { call }.to raise_error(ResourceQuotable::AbstractClassError) }

      describe 'subclass' do
        subject(:call) { subclass_mock.call }

        let(:subclass_mock) do
          Class.new(described_class) do
            def self.quotum_in_period; end

            def quotum_in_period
              self.class.quotum_in_period
            end
          end
        end

        let(:limit1) { limits_to_reset1.first }
        let(:limit2) { limits_to_reset1.last }
        let(:limit3) { limits_to_reset2.first }
        let(:limit4) { limits_to_reset2.last }
        let(:limit5) { weekly_limits.first }
        let(:limit6) { weekly_limits.last }

        before do
          allow(subclass_mock).to receive(:quotum_in_period).and_return(QuotumLimit.where(id: limits_ids))
        end

        it { expect { call }.to change { limit1.reload.counter }.from(10).to(0) }
        it { expect { call }.to change { limit1.reload.flag }.from(true).to(false) }
        it { expect { call }.to change { limit2.reload.counter }.from(10).to(0) }
        it { expect { call }.to change { limit2.reload.flag }.from(true).to(false) }
        it { expect { call }.to change { limit3.reload.counter }.from(10).to(0) }
        it { expect { call }.not_to change { limit3.reload.flag }.from(false) }
        it { expect { call }.to change { limit4.reload.counter }.from(10).to(0) }
        it { expect { call }.not_to change { limit4.reload.flag }.from(false) }

        it { expect { call }.not_to change { limit5.reload.counter }.from(10) }
        it { expect { call }.not_to change { limit5.reload.flag }.from(true) }
        it { expect { call }.not_to change { limit6.reload.counter }.from(10) }
        it { expect { call }.not_to change { limit6.reload.flag }.from(true) }
      end
    end
  end
end
