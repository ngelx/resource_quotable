# frozen_string_literal: true

require 'rails_helper'

module ResourceQuotable
  RSpec.describe QuotumLimitsController do
    routes { ResourceQuotable::Engine.routes }

    describe 'GET index' do
      subject(:index) { get :index }

      let(:quotum_limits) { create_list(:quotum_limit, 3) }

      before do
        quotum_limits
        index
      end

      it 'test allowed_to_manage_quota?'
      it { expect(assigns(:quotum_limits)).to eq(quotum_limits) }
      it { expect(response).to render_template('index') }
    end

    describe 'GET show' do
      subject(:show) { get :show, params: { id: quotum_limit.id } }

      let(:quotum_limit) { create(:quotum_limit) }

      before { show }

      it 'test allowed_to_manage_quota?'
      it { expect(assigns(:quotum_limit)).to eq(quotum_limit) }
      it { expect(response).to render_template('show') }
    end

    describe 'GET new' do
      subject(:get_new) { get :new }

      it 'test allowed_to_manage_quota?'

      before { get_new }

      it { expect(assigns(:quotum)).to be_kind_of(ResourceQuotable::Quotum) }
      it { expect(assigns(:quotum).persisted?).to be false }
      it { expect(assigns(:quotum).quotum_limits.first).to be_kind_of(ResourceQuotable::QuotumLimit) }
      it { expect(response).to render_template('new') }
    end

    describe 'POST create' do
      subject(:create) { post :create, params: { quotum: { user_id: 1, resource_class: 'ClassA', action: 'destroy', quotum_limit: { limit: 10, period: 'daily' } } } }

      let(:quotum_limit) { build(:quotum_limit) }
      let(:mock_service) { allow(ResourceQuotable::Create).to receive(:call).with({ user_id: '1', resource: 'ClassA', action: :destroy, period: :daily, limit: '10' }).and_return(quotum_limit) }

      before do
        mock_service
        create
      end

      it 'test allowed_to_manage_quota?'
      it { expect(ResourceQuotable::Create).to have_received(:call).with({ user_id: '1', resource: 'ClassA', action: :destroy, period: :daily, limit: '10' }) }
      it { expect(response).to render_template('create') }
      it { expect(assigns(:quotum_limit)).to eq(quotum_limit) }
    end

    describe 'GET edit' do
      subject(:edit) { get :edit, params: { id: quotum_limit.id } }

      let(:quotum_limit) { create(:quotum_limit) }

      before { edit }

      it 'test allowed_to_manage_quota?'
      it { expect(assigns(:quotum_limit)).to eq(quotum_limit) }
      it { expect(response).to render_template('edit') }
    end

    describe 'PUT update' do
      subject(:update) { put :update, params: { id: quotum_limit.id, quotum_limit: { limit: 10 } } }

      let(:quotum_limit) { create(:quotum_limit, limit: 10) }
      let(:mock_service) { allow(ResourceQuotable::Update).to receive(:call).with({ quotum_limit: quotum_limit, limit: '10' }).and_return(quotum_limit) }

      before do
        mock_service
        update
      end

      it 'test allowed_to_manage_quota?'
      it { expect(ResourceQuotable::Update).to have_received(:call).with({ quotum_limit: quotum_limit, limit: '10' }) }
      it { expect(response).to render_template('update') }
      it { expect(assigns(:quotum_limit)).to eq(quotum_limit) }
    end

    describe 'DELETE destroy' do
      subject(:destroy) { delete :destroy, params: { id: quotum_limit.id } }

      let(:quotum_limit) { create(:quotum_limit) }

      let(:mock_service) { allow(ResourceQuotable::Destroy).to receive(:call).with({ quotum_limit: quotum_limit }).and_return(true) }

      before do
        mock_service
        destroy
      end

      it 'test allowed_to_manage_quota?'
      it { expect(ResourceQuotable::Destroy).to have_received(:call).with({ quotum_limit: quotum_limit }) }
      it { expect(response).to render_template('destroy') }
      it { expect(assigns(:quotum_limit)).to eq(quotum_limit) }
      it { expect(assigns(:id)).to eq(quotum_limit.id) }
    end
  end
end
