# frozen_string_literal: true

# == Schema Information
#
# Table name: resource_quotable_quotum_trackers
#
#  id        :integer          not null, primary key
#  counter   :integer          default(0), not null
#  flag      :boolean          default(FALSE), not null
#  user_type :string           not null
#  quotum_id :integer          not null
#  user_id   :integer          not null
#
# Indexes
#
#  index_resource_quotable_quotum_trackers_on_quotum_id  (quotum_id)
#  index_resource_quotable_quotum_trackers_on_user_id    (user_id)
#  resource_quotable_quotum_trackers_unique_index        (user_id,quotum_id) UNIQUE
#
require 'rails_helper'

module ResourceQuotable
  RSpec.describe QuotumTracker, type: :model do
    describe 'Basic' do
      it { is_expected.to belong_to(:quotum) }
      it { is_expected.to belong_to(:user) }

      it { is_expected.to validate_presence_of(:counter) }
    end

    describe 'increment!' do
      subject(:increment) { tracker.increment! }

      let(:quotum) { build_stubbed(:quotum) }

      before { allow(quotum).to receive(:limit).and_return(10) }

      describe 'inside limits' do
        let(:tracker) { create(:quotum_tracker, quotum: quotum, counter: 1, flag: false) }

        it { expect { increment }.to change(tracker, :counter).from(1).to(2) }
        it { expect { increment }.not_to change(tracker, :flag).from(false) }
      end

      describe 'reaching limit' do
        let(:tracker) { create(:quotum_tracker, quotum: quotum, counter: 9, flag: false) }

        it { expect { increment }.to change(tracker, :counter).from(9).to(10) }
        it { expect { increment }.to change(tracker, :flag).from(false).to(true) }
      end

      describe 'over limit' do
        let(:tracker) { create(:quotum_tracker, quotum: quotum, counter: 10, flag: true) }

        it { expect { increment }.to raise_error ResourceQuotable::QuotaLimitError }
      end
    end

    describe 'increment_by!' do
      subject(:increment_by) { tracker.increment_by!(20) }

      let(:quotum) { build_stubbed(:quotum, limit: 30) }

      # before { allow(quotum).to receive(:limit).and_return(10) }

      describe 'inside limits' do
        let(:tracker) { create(:quotum_tracker, quotum: quotum, counter: 1, flag: false) }

        it { expect { increment_by }.to change(tracker, :counter).from(1).to(21) }
        it { expect { increment_by }.not_to change(tracker, :flag).from(false) }
      end

      describe 'reaching limit' do
        let(:tracker) { create(:quotum_tracker, quotum: quotum, counter: 10, flag: false) }

        it { expect { increment_by }.to change(tracker, :counter).from(10).to(30) }
        it { expect { increment_by }.to change(tracker, :flag).from(false).to(true) }
      end

      describe 'over limit' do
        let(:tracker) { create(:quotum_tracker, quotum: quotum, counter: 11, flag: false) }

        it { expect { increment_by }.to raise_error ResourceQuotable::QuotaMulitLimitError }
      end
    end

    describe 'reset!' do
      subject(:reset!) { tracker.reset! }

      describe 'counter 0' do
        let(:tracker) { create(:quotum_tracker, counter: 0, flag: false) }

        it { expect { reset! }.not_to change(tracker, :counter).from(0) }

        it { expect { reset! }.not_to change(tracker, :flag).from(false) }
      end

      describe 'counter not 0' do
        let(:tracker) { create(:quotum_tracker, counter: 10, flag: true) }

        it { expect { reset! }.to change(tracker, :counter).from(10).to(0) }

        it { expect { reset! }.to change(tracker, :flag).from(true).to(false) }
      end
    end

    describe 'for_user' do
      subject(:for_user) { described_class.for_user(user) }

      let(:user) { create(:admin_user) }
      let(:result) { create_list(:quotum_tracker, 3, user: user) }

      before do
        create(:quotum_tracker)
        result
        create(:quotum_tracker)
      end

      it { expect(for_user).to be_kind_of(ActiveRecord::Relation) }
      it { expect(for_user.to_a).to eq(result) }
    end

    describe 'with_active_counter'
  end
end
