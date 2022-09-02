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
      let(:trackers_to_reset1) { create_list(:quotum_tracker, 2, counter: 10, quotum: quotum1, flag: true) }
      let(:trackers_to_reset2) { create_list(:quotum_tracker, 2, counter: 10, quotum: quotum2, flag: false) }
      let(:trackers_not_to_reset) { create_list(:quotum_tracker, 2, counter: 0, flag: true) }
      let(:trackers_not_to_reset2) { create_list(:quotum_tracker, 2, quotum: quotum3, counter: 10, flag: true) }

      before do
        trackers_to_reset1
        trackers_to_reset2
        trackers_not_to_reset
        trackers_not_to_reset2
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

        let(:tracker1) { trackers_to_reset1.first }
        let(:tracker2) { trackers_to_reset1.last }
        let(:tracker3) { trackers_to_reset2.first }
        let(:tracker4) { trackers_to_reset2.last }
        let(:tracker5) { trackers_not_to_reset.first }
        let(:tracker6) { trackers_not_to_reset.last }
        let(:tracker7) { trackers_not_to_reset2.first }
        let(:tracker8) { trackers_not_to_reset2.last }

        before do
          allow(subclass_mock).to receive(:quotum_in_period).and_return([quotum1, quotum2])
        end

        it { expect { call }.to change { tracker1.reload.counter }.from(10).to(0) }
        it { expect { call }.to change { tracker1.reload.flag }.from(true).to(false) }
        it { expect { call }.to change { tracker2.reload.counter }.from(10).to(0) }
        it { expect { call }.to change { tracker2.reload.flag }.from(true).to(false) }
        it { expect { call }.to change { tracker3.reload.counter }.from(10).to(0) }
        it { expect { call }.not_to change { tracker3.reload.flag }.from(false) }
        it { expect { call }.to change { tracker4.reload.counter }.from(10).to(0) }
        it { expect { call }.not_to change { tracker4.reload.flag }.from(false) }

        it { expect { call }.not_to change { tracker5.reload.counter }.from(0) }
        it { expect { call }.not_to change { tracker5.reload.flag }.from(true) }
        it { expect { call }.not_to change { tracker6.reload.counter }.from(0) }
        it { expect { call }.not_to change { tracker6.reload.flag }.from(true) }

        it { expect { call }.not_to change { tracker7.reload.counter }.from(10) }
        it { expect { call }.not_to change { tracker7.reload.flag }.from(true) }
        it { expect { call }.not_to change { tracker8.reload.counter }.from(10) }
        it { expect { call }.not_to change { tracker8.reload.flag }.from(true) }
      end
    end
  end
end
