# frozen_string_literal: true

require 'rails_helper'

module ResourceQuotable
  RSpec.describe Reset::Weekly do
    include Shoulda::Matchers::ActiveModel

    let(:abstract_class) do
      Class.new(described_class) do
        def call
          quotum_in_period
        end
      end
    end

    describe 'Basic' do
      it { is_expected.to be_kind_of(ResourceQuotable::Base) }
      it { is_expected.to be_kind_of(ResourceQuotable::Reset::Base) }
    end

    describe 'quotum_in_period' do
      subject(:quotum_in_period) { abstract_class.call }

      let(:daily_quota) { create_list(:quotum, 3, period: :daily) }
      let(:weekly_quota) { create_list(:quotum, 3, period: :weekly) }
      let(:monthly_quota) { create_list(:quotum, 3, period: :monthly) }
      let(:yearly_quota) { create_list(:quotum, 3, period: :yearly) }
      let(:any_quota) { create_list(:quotum, 3, period: :any) }

      before do
        daily_quota
        weekly_quota
        monthly_quota
        yearly_quota
        any_quota
      end

      it { expect(quotum_in_period).to eq weekly_quota }
    end
  end
end
