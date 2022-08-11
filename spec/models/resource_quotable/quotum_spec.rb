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
  end
end
