require 'rails_helper'

RSpec.describe UserGroup, type: :model do
  describe 'ActsAsQuotable' do
    let(:user_group) { build(:user_group) }

    it { is_expected.to have_many(:quota) }
  end
end
