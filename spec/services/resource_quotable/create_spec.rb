# frozen_string_literal: true

require 'rails_helper'

module ResourceQuotable
  RSpec.describe Create do
    include Shoulda::Matchers::ActiveModel

    describe 'Basic' do
      it { is_expected.to be_kind_of(ResourceQuotable::Base) }

      it { is_expected.to validate_presence_of(:user_id) }
      it { is_expected.to validate_presence_of(:resource) }
      it { is_expected.to validate_inclusion_of(:action).in_array(%i[create update destroy]) }
      it { is_expected.to validate_inclusion_of(:period).in_array(%i[any daily weekly monthly yearly]) }
      it { is_expected.to validate_numericality_of(:limit).only_integer.is_greater_than_or_equal_to(0) }
    end

    describe 'call' do
      subject(:call) { described_class.call(user_id: user.id, resource: 'ResourceA', action: :create, period: :daily, limit: limit) }

      let(:user) { create(:admin_user) }
      let(:limit) { 10 }

      describe 'new quotum, new limit' do
        it { expect { call }.to change(Quotum, :count).by(1) }
        it { expect { call }.to change(QuotumLimit, :count).by(1) }
        it { expect(call).to be_kind_of(QuotumLimit) }
        it { expect(call.user).to eq user }
        it { expect(call.limit).to eq 10 }
        it { expect(call.counter).to eq 0 }
        it { expect(call.period).to eq 'daily' }
        it { expect(call.flag).to be false }
        it { expect(call.quotum.resource_class).to eq 'ResourceA' }
        it { expect(call.quotum.action).to eq 'create' }
        it { expect(call.quotum.flag).to be false }
      end

      describe 'limit 0' do
        let(:limit) { 0 }

        it { expect { call }.to change(Quotum, :count).by(1) }
        it { expect { call }.to change(QuotumLimit, :count).by(1) }
        it { expect(call).to be_kind_of(QuotumLimit) }
        it { expect(call.user).to eq user }
        it { expect(call.limit).to eq 0 }
        it { expect(call.counter).to eq 0 }
        it { expect(call.period).to eq 'daily' }
        it { expect(call.flag).to be true }
        it { expect(call.quotum.resource_class).to eq 'ResourceA' }
        it { expect(call.quotum.action).to eq 'create' }
        it { expect(call.quotum.flag).to be true }
      end

      describe 'existing quotum, new limit' do
        let(:quotum) { create(:quotum, user: user, resource_class: 'ResourceA', action: 'create') }

        before { quotum }

        it { expect { call }.not_to change(Quotum, :count) }
        it { expect { call }.to change(QuotumLimit, :count).by(1) }
        it { expect(call).to be_kind_of(QuotumLimit) }
        it { expect(call.user).to eq user }
        it { expect(call.limit).to eq 10 }
        it { expect(call.counter).to eq 0 }
        it { expect(call.period).to eq 'daily' }
        it { expect(call.flag).to be false }
        it { expect(call.quotum).to eq quotum }
      end

      describe 'existing quotum, existing limit' do
        let(:quotum) { create(:quotum, user: user, resource_class: 'ResourceA', action: 'create') }
        let(:quotum_limit) { create(:quotum_limit, quotum: quotum, period: :daily) }

        before { quotum_limit }

        it { expect { call }.to raise_error QuotaLimitDuplicateError }
      end
    end
  end
end
