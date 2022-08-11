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
  end
end
