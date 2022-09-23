# frozen_string_literal: true

require 'rails_helper'

module ResourceQuotable
  module ActionServices
    RSpec.describe CheckMultiple do
      include Shoulda::Matchers::ActiveModel

      describe 'Basic' do
        it { is_expected.to be_kind_of(ResourceQuotable::Base) }
        it { is_expected.to be_kind_of(ResourceQuotable::ActionServices::Base) }

        it { is_expected.to validate_presence_of(:user) }
        it { is_expected.to validate_presence_of(:amount) }
        it { is_expected.to validate_presence_of(:resource) }
        it { is_expected.to validate_inclusion_of(:action).in_array(%i[create update destroy]) }
      end

      describe 'call' do
        subject(:call) { described_class.call(user: user, resource: 'ResourceA', action: :create, amount: 20) }

        let(:user) { build_stubbed(:admin_user) }
        let(:quotum1) { build_stubbed(:quotum, limit: 30) }
        let(:quotum2) { build_stubbed(:quotum, limit: 30) }
        let(:tracker1) { build_stubbed(:quotum_tracker, counter: 0, quotum: quotum1) }
        let(:tracker2) { build_stubbed(:quotum_tracker, counter: 0, quotum: quotum2) }

        before do
          allow(user).to receive(:quota_for_resource_action).and_return([quotum1, quotum2])
          # rubocop:disable RSpec/AnyInstance
          # We know what we are doing.
          allow_any_instance_of(described_class).to receive(:find_or_create_quotum_tracker).with(quotum1).and_return(tracker1)
          allow_any_instance_of(described_class).to receive(:find_or_create_quotum_tracker).with(quotum2).and_return(tracker2)
          # rubocop:enable RSpec/AnyInstance
          call
        end

        it { expect(call).to be false }

        describe 'Limit reach but not exceded' do
          let(:tracker1) { build_stubbed(:quotum_tracker, counter: 10, quotum: quotum1) }

          it { expect(call).to be false }
        end

        describe 'Limit exceded' do
          let(:tracker1) { build_stubbed(:quotum_tracker, counter: 11, quotum: quotum1) }

          it { expect(call).to be true }
        end
      end
    end
  end
end
