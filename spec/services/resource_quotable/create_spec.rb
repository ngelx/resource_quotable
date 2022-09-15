# frozen_string_literal: true

require 'rails_helper'

module ResourceQuotable
  RSpec.describe Create do
    include Shoulda::Matchers::ActiveModel

    describe 'Basic' do
      it { is_expected.to be_kind_of(ResourceQuotable::Base) }

      it { is_expected.to validate_presence_of(:group) }
      it { is_expected.to validate_presence_of(:resource) }
      it { is_expected.to validate_inclusion_of(:action).in_array(%i[create update destroy]) }
      it { is_expected.to validate_inclusion_of(:period).in_array(%i[any daily weekly monthly yearly]) }
      it { is_expected.to validate_numericality_of(:limit).only_integer.is_greater_than_or_equal_to(0) }
    end

    describe 'call' do
      subject(:call) { described_class.call(group: group, resource: 'ResourceA', action: :create, period: :daily, limit: limit) }

      let(:group) { create(:user_group) }
      let(:user_from_other_group) { create(:admin_user) }
      let(:limit) { 10 }

      before { create_list(:admin_user, 3, user_group: group) }

      describe 'new quotum' do
        it { expect { call }.to change(Quotum, :count).by(1) }
        it { expect { call }.to change(QuotumTracker, :count).by(3) }
        it { expect(call).to be_kind_of(Quotum) }
        it { expect(call.group).to eq group }
        it { expect(call.limit).to eq 10 }
        it { expect(call.period).to eq 'daily' }
        it { expect(call.resource_class).to eq 'ResourceA' }
        it { expect(call.action).to eq 'create' }

        it { expect(call.quotum_trackers.first.flag).to be false }
        it { expect(call.quotum_trackers.first.counter).to eq 0 }
      end

      describe 'limit 0' do
        let(:limit) { 0 }

        it { expect { call }.to change(Quotum, :count).by(1) }
        it { expect { call }.to change(QuotumTracker, :count).by(3) }
        it { expect(call.limit).to eq 0 }
        it { expect(call.quotum_trackers.first.flag).to be true }
        it { expect(call.quotum_trackers.first.counter).to eq 0 }
      end

      it 'existing quotum' do
        create(:quotum, group: group, resource_class: 'ResourceA', action: 'create', period: :daily, limit: limit)
        expect { call }.to raise_error(ResourceQuotable::QuotaDuplicateError)
      end
    end
  end
end
