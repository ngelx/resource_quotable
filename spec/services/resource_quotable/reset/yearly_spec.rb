# frozen_string_literal: true

require 'rails_helper'

module ResourceQuotable
  RSpec.describe Reset::Yearly do
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

      let(:daily_limits) { create_list(:quotum_limit, 3, period: :daily) }
      let(:weekly_limits) { create_list(:quotum_limit, 3, period: :weekly) }
      let(:monthly_limits) { create_list(:quotum_limit, 3, period: :monthly) }
      let(:yearly_limits) { create_list(:quotum_limit, 3, period: :yearly) }
      let(:any_limits) { create_list(:quotum_limit, 3, period: :any) }

      before do
        daily_limits
        weekly_limits
        monthly_limits
        yearly_limits
        any_limits
      end

      it { expect(quotum_in_period).to eq yearly_limits }
    end
  end
end
