# == Schema Information
#
# Table name: resource_quotable_quota
#
#  id             :integer          not null, primary key
#  action         :integer
#  flag           :boolean
#  resource_class :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer          not null
#
# Indexes
#
#  index_resource_quotable_quota_on_user_id  (user_id)
#

# frozen_string_literal: true

require 'rails_helper'

module ResourceQuotable
  RSpec.describe Quotum, type: :model do
    describe 'Basic' do
      # subject { quo }

      it { is_expected.to belong_to(:user) }
      it { is_expected.to have_many(:quotum_limits) }

      it { is_expected.to validate_presence_of(:resource_class) }
      it { is_expected.to validate_presence_of(:action) }
    end

    describe 'check_flag' do
      subject(:check_flag) { quotum.check_flag! }

      let(:quotum) { create(:quotum, flag: false) }

      it 'No flag' do
        create(:quotum_limit, quotum: quotum, flag: false)
        create(:quotum_limit, quotum: quotum, flag: false)
        expect { check_flag }.not_to change(quotum, :flag).from(false)
      end

      it '1 flag' do
        create(:quotum_limit, quotum: quotum, flag: false)
        create(:quotum_limit, quotum: quotum, flag: true)
        expect { check_flag }.to change(quotum, :flag).from(false).to(true)
      end

      it 'All flag' do
        create(:quotum_limit, quotum: quotum, flag: true)
        create(:quotum_limit, quotum: quotum, flag: true)
        expect { check_flag }.to change(quotum, :flag).from(false).to(true)
      end

      describe 'already true' do
        before { quotum.update(flag: true) }

        it 'Any flag true' do
          create(:quotum_limit, quotum: quotum, flag: false)
          create(:quotum_limit, quotum: quotum, flag: true)
          expect { check_flag }.not_to change(quotum, :flag).from(true)
        end

        it 'All flag to false' do
          create(:quotum_limit, quotum: quotum, flag: false)
          create(:quotum_limit, quotum: quotum, flag: false)
          expect { check_flag }.to change(quotum, :flag).from(true).to(false)
        end
      end
    end

    describe 'increment!' do
      subject(:increment!) { quotum.increment! }

      let(:quotum) { build(:quotum) }
      let(:limit1) { build_stubbed(:quotum_limit, quotum: quotum) }
      let(:limit2) { build_stubbed(:quotum_limit, quotum: quotum) }
      let(:other_limit) { build_stubbed(:quotum_limit) }

      before do
        quotum.quotum_limits = [limit1, limit2]
        other_limit
        allow(limit1).to receive(:increment!)
        allow(limit2).to receive(:increment!)
        allow(other_limit).to receive(:increment!)
        allow(quotum).to receive(:check_flag!)
      end

      it 'over limit' do
        quotum.flag = true
        expect { increment! }.to raise_error ResourceQuotable::QuotaLimitError
      end

      it 'increase limit1' do
        increment!
        expect(limit1).to have_received(:increment!)
      end

      it 'increase limit2' do
        increment!
        expect(limit2).to have_received(:increment!)
      end

      it 'do not increase other_limit' do
        increment!
        expect(other_limit).not_to have_received(:increment!)
      end

      it 'called check_flag!' do
        increment!
        expect(quotum).to have_received(:check_flag!)
      end
    end
  end
end
