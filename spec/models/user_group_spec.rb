require 'rails_helper'

RSpec.describe UserGroup, type: :model do
  describe 'ActsAsQuotable' do
    let(:user_group) { build(:user_group) }

    it { is_expected.to have_many(:quota) }
    it { is_expected.to respond_to(:resource_quotable_users) }
    it { is_expected.not_to respond_to(:resource_quotable_group) }

  end
end
