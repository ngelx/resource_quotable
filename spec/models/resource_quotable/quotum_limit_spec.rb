# == Schema Information
#
# Table name: resource_quotable_quotum_limits
#
#  id        :integer          not null, primary key
#  counter   :integer          default(0), not null
#  flag      :boolean          default(FALSE), not null
#  limit     :integer          default(1), not null
#  period    :integer          default(0), not null
#  quotum_id :integer          not null
#
# Indexes
#
#  index_resource_quotable_quotum_limits_on_quotum_id  (quotum_id)
#

# frozen_string_literal: true

require 'rails_helper'

module ResourceQuotable
  RSpec.describe QuotumLimit, type: :model do
    describe 'Basic' do
      it { is_expected.to belong_to(:quotum) }

      it { is_expected.to validate_presence_of(:counter) }
      it { is_expected.to validate_presence_of(:limit) }
      it { is_expected.to validate_presence_of(:period) }
    end

    describe 'increment!' do
      subject(:increment) { limit.increment! }

      describe 'inside limits' do
        let(:limit) { create(:quotum_limit, limit: 10, counter: 1, flag: false) }

        it { expect { increment }.to change(limit, :counter).from(1).to(2) }
        it { expect { increment }.not_to change(limit, :flag).from(false) }
      end

      describe 'reaching limit' do
        let(:limit) { create(:quotum_limit, limit: 10, counter: 9, flag: false) }

        it { expect { increment }.to change(limit, :counter).from(9).to(10) }
        it { expect { increment }.to change(limit, :flag).from(false).to(true) }
      end

      describe 'over limit' do
        let(:limit) { create(:quotum_limit, limit: 10, counter: 10, flag: true) }

        it { expect { increment }.to raise_error ResourceQuotable::QuotaLimitError }
      end
    end
  end
end
