# frozen_string_literal: true

require 'rails_helper'

module ResourceQuotable
  module ActionServices
    RSpec.describe Base do
      include Shoulda::Matchers::ActiveModel

      describe 'Basic' do
        it { is_expected.to be_kind_of(ResourceQuotable::Base) }

        it { is_expected.to validate_presence_of(:user) }
        it { is_expected.to validate_presence_of(:resource) }
        it { is_expected.to validate_inclusion_of(:action).in_array(%i[create update destroy]) }
      end

      describe 'find_or_create_quotum_tracker' do
        subject(:call) { subclass_mock.call(user: user, resource: resource, action: action) }

        let(:subclass_mock) do
          Class.new(described_class) do
            def call
              quotum = user.quota_for_resource_action(resource, action).first
              find_or_create_quotum_tracker(quotum)
            end
          end
        end

        let(:resource) { 'ResourceX' }
        let(:action) { :create }
        let(:user) { create(:admin_user) }
        let(:quotum) { create(:quotum) }

        before { allow(user).to receive(:quota_for_resource_action).and_return([quotum]) }

        it 'Tracker exists' do
          quotum_tracker = create(:quotum_tracker, quotum: quotum, user: user)
          expect(call).to eq quotum_tracker
        end

        describe 'Tracker does not exists' do
          describe 'Quota has limit greater than 0' do
            it { expect { call }.to change { user.quotum_trackers.count }.from(0).to(1) }
            it { expect(call.counter).to be 0 }
            it { expect(call.flag).to be false }
          end

          describe 'Quota has limit 0' do
            let(:quotum) { create(:quotum, limit: 0) }

            it { expect { call }.to change { user.quotum_trackers.count }.from(0).to(1) }
            it { expect(call.counter).to be 0 }
            it { expect(call.flag).to be true }
          end
        end
      end
    end
  end
end
