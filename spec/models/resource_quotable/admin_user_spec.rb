require 'rails_helper'

module ResourceQuotable
  RSpec.describe AdminUser, type: :model do
    describe 'ActsAsQuotable' do
      let(:admin_user) { build(:admin_user) }

      it { is_expected.to have_many(:quota) }

      it { expect(admin_user.quota_for?(action: :create,resource: :some)).to be true }
    end
  end
end
