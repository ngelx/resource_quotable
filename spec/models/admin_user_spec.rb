# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  describe 'acts_as_quota_trackable' do
    let(:admin_user) { build(:admin_user) }

    it { is_expected.to have_many(:quotum_trackers) }

    # describe 'allowed_to?' do
    #   before do
    #     admin_user.save!
    #     # quotum_reach
    #     create(:quotum, user: admin_user, resource_class: 'ResourceX', action: :create, flag: true)
    #     # quotum_available
    #     create(:quotum, user: admin_user, resource_class: 'ResourceX', action: :update, flag: false)
    #     # quotum_noice
    #     create(:quotum, user: admin_user, resource_class: 'ResourceY', action: :create, flag: false)
    #     # quotum_from_other_user
    #     create(:quotum, resource_class: 'ResourceX', action: :create, flag: false)
    #     create(:quotum, resource_class: 'ResourceY', action: :update, flag: true)
    #   end
    #
    #   it { expect(admin_user.allowed_to?(action: :create, resource: 'ResourceX')).to be false }
    #   it { expect(admin_user.allowed_to?(action: :update, resource: 'ResourceX')).to be true }
    #   it { expect(admin_user.allowed_to?(action: :destroy, resource: 'ResourceX')).to be true }
    #   it { expect(admin_user.allowed_to?(action: :create, resource: 'ResourceY')).to be true }
    #   it { expect(admin_user.allowed_to?(action: :update, resource: 'ResourceY')).to be true }
    # end
  end
end
