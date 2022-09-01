# == Schema Information
#
# Table name: resource_quotable_quota
#
#  id             :integer          not null, primary key
#  action         :integer          default("create"), not null
#  limit          :integer          default(1), not null
#  period         :integer          default("any"), not null
#  resource_class :string           not null
#  created_at     :datetime
#  updated_at     :datetime
#  group_id       :integer          not null
#
# Indexes
#
#  index_resource_quotable_quota_on_group_id  (group_id)
#  resource_quotable_quota_unique_index       (group_id,resource_class,action,period) UNIQUE
#

# frozen_string_literal: true

require 'rails_helper'

module ResourceQuotable
  RSpec.describe Quotum, type: :model do
    describe 'Basic' do
      it { is_expected.to belong_to(:group) }
      it { is_expected.to have_many(:quotum_trackers) }

      it { is_expected.to validate_presence_of(:resource_class) }
      it { is_expected.to validate_presence_of(:action) }
      it { is_expected.to validate_presence_of(:limit) }
      it { is_expected.to validate_presence_of(:period) }
    end
  end
end
