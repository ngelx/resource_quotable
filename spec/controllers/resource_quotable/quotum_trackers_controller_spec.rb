# frozen_string_literal: true

require 'rails_helper'

module ResourceQuotable
  RSpec.describe QuotumTrackersController do
    routes { ResourceQuotable::Engine.routes }

    describe 'PUT reset' do
      subject(:reset) { put :reset, params: { id: quotum_tracker.id }, xhr: xhr }

      let(:xhr) { false }
      let(:quotum_tracker) { create(:quotum_tracker) }
      let(:mock_service) { allow(ResourceQuotable::QuotumTrackerServices::Reset).to receive(:call).with({ quotum_tracker: quotum_tracker }).and_return(quotum_tracker) }

      it 'test allowed_to_manage_quota? false' do
        allow(controller).to receive(:allowed_to_manage_quota?).and_return(false)
        expect { reset }.to raise_error(ResourceQuotable::AuthorizationError)
      end

      describe 'JS format' do
        let(:xhr) { true }

        before do
          mock_service
          reset
        end

        it { expect(ResourceQuotable::QuotumTrackerServices::Reset).to have_received(:call).with({ quotum_tracker: quotum_tracker }) }
        it { expect(assigns(:quotum_tracker)).to eq(quotum_tracker) }
        it { expect(response.content_type).to eq 'text/javascript; charset=utf-8' }
        it { expect(response).to render_template(:reset) }
      end
    end
  end
end
