# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  describe 'acts_as_quota_trackable' do
    let(:admin_user) { build(:admin_user) }

    it { is_expected.to have_many(:quotum_trackers) }
    it { is_expected.to respond_to(:resource_quotable_group) }
    it { is_expected.not_to respond_to(:resource_quotable_users) }

    describe 'resource_quotable_group' do
      subject(:resource_quotable_group) { admin_user.resource_quotable_group }

      let(:admin_user) { create(:admin_user) }

      it { expect(resource_quotable_group).to eq(admin_user.user_group) }
    end

    describe 'quota_for_resource_action' do
      subject(:quota_for_resource_action) { admin_user.quota_for_resource_action(resource, action) }

      let(:admin_user) { create(:admin_user) }
      let(:group) { admin_user.user_group }
      let(:resource) { 'ResourceA' }
      let(:action) { :create }
      let(:quotum1) { create(:quotum, group: group, resource_class: resource, action: action, period: :daily) }
      let(:quotum2) { create(:quotum, group: group, resource_class: resource, action: action, period: :weekly) }

      before do
        quotum1
        quotum2
        # noise
        create(:quotum, resource_class: resource, action: action)
        create(:quotum, group: group, resource_class: 'Other', action: action, period: :daily)
        create(:quotum, group: group, resource_class: resource, action: :update, period: :weekly)
      end

      it { expect(quota_for_resource_action.to_a).to eq([quotum1, quotum2]) }
    end
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
