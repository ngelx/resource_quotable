# frozen_string_literal: true

require 'rails_helper'

module ResourceQuotable
  RSpec.describe QuotumLimitsController do
    routes { ResourceQuotable::Engine.routes }

    describe 'GET index' do
      subject(:index) { get :index }

      let(:quotum_limits) { create_list(:quotum_limit, 3) }

      before { quotum_limits }

      it 'Accept js format' do
        get :index, xhr: true
        expect(response.content_type).to eq 'text/javascript; charset=utf-8'
      end

      it 'test allowed_to_manage_quota?' do
        allow(controller).to receive(:allowed_to_manage_quota?).and_return(false)
        expect { index }.to raise_error(ResourceQuotable::AuthorizationError)
      end

      describe 'test allowed_to_manage_quota? true' do
        before { index }

        it { expect(response.content_type).to eq 'text/html; charset=utf-8' }
        it { expect(assigns(:quotum_limits)).to eq(quotum_limits) }
        it { expect(response).to render_template('index') }
      end
    end

    describe 'GET show' do
      subject(:show) { get :show, params: { id: quotum_limit.id } }

      let(:quotum_limit) { create(:quotum_limit) }

      it 'test allowed_to_manage_quota?' do
        allow(controller).to receive(:allowed_to_manage_quota?).and_return(false)
        expect { show }.to raise_error(ResourceQuotable::AuthorizationError)
      end

      it 'Accept js format' do
        get :show, params: { id: quotum_limit.id }, xhr: true
        expect(response.content_type).to eq 'text/javascript; charset=utf-8'
      end

      describe 'test allowed_to_manage_quota? true' do
        before { show }

        it { expect(response.content_type).to eq 'text/html; charset=utf-8' }
        it { expect(assigns(:quotum_limit)).to eq(quotum_limit) }
        it { expect(response).to render_template('show') }
      end
    end

    describe 'GET new' do
      subject(:get_new) { get :new }

      it 'test allowed_to_manage_quota?' do
        allow(controller).to receive(:allowed_to_manage_quota?).and_return(false)
        expect { get_new }.to raise_error(ResourceQuotable::AuthorizationError)
      end

      it 'Accept js format' do
        get :new, xhr: true
        expect(response.content_type).to eq 'text/javascript; charset=utf-8'
      end

      describe 'test allowed_to_manage_quota? true' do
        before { get_new }

        it { expect(response.content_type).to eq 'text/html; charset=utf-8' }
        it { expect(assigns(:quotum_limit)).to be_kind_of(ResourceQuotable::QuotumLimit) }
        it { expect(assigns(:quotum_limit).persisted?).to be false }
        it { expect(assigns(:quotum_limit).quotum).to be_kind_of(ResourceQuotable::Quotum) }
        it { expect(response).to render_template('new') }
      end
    end

    describe 'POST create' do
      subject(:create) { post :create, params: { quotum_limit: { limit: 10, period: 'daily', quotum: { user_id: 1, resource_class: 'ClassA', action: 'destroy' } } }, xhr: xhr }

      let(:xhr) { false }
      let(:quotum_limit) { build(:quotum_limit) }
      let(:mock_service) { allow(ResourceQuotable::Create).to receive(:call).with({ user_id: '1', resource: 'ClassA', action: :destroy, period: :daily, limit: '10' }).and_return(quotum_limit) }

      it 'test allowed_to_manage_quota?' do
        allow(controller).to receive(:allowed_to_manage_quota?).and_return(false)
        expect { create }.to raise_error(ResourceQuotable::AuthorizationError)
      end

      describe 'JS format' do
        let(:xhr) { true }

        before do
          mock_service
          create
        end

        it { expect(response.content_type).to eq 'text/javascript; charset=utf-8' }
        it { expect(response).to render_template('create') }
      end

      describe 'test allowed_to_manage_quota? true' do
        before do
          mock_service
          create
        end

        it { expect(ResourceQuotable::Create).to have_received(:call).with({ user_id: '1', resource: 'ClassA', action: :destroy, period: :daily, limit: '10' }) }
        it { expect(assigns(:quotum_limit)).to eq(quotum_limit) }
        it { expect(response).to redirect_to(action: :index) }
        it { expect(response.content_type).to eq 'text/html; charset=utf-8' }
      end
    end

    describe 'GET edit' do
      subject(:edit) { get :edit, params: { id: quotum_limit.id } }

      let(:quotum_limit) { create(:quotum_limit) }

      it 'test allowed_to_manage_quota?' do
        allow(controller).to receive(:allowed_to_manage_quota?).and_return(false)
        expect { edit }.to raise_error(ResourceQuotable::AuthorizationError)
      end

      it 'Accept js format' do
        get :edit, params: { id: quotum_limit.id }, xhr: true
        expect(response.content_type).to eq 'text/javascript; charset=utf-8'
      end

      describe 'test allowed_to_manage_quota? true' do
        before { edit }

        it { expect(assigns(:quotum_limit)).to eq(quotum_limit) }
        it { expect(response).to render_template('edit') }
        it { expect(response.content_type).to eq 'text/html; charset=utf-8' }
      end
    end

    describe 'PUT update' do
      subject(:update) { put :update, params: { id: quotum_limit.id, quotum_limit: { limit: 10 } }, xhr: xhr }

      let(:xhr) { false }
      let(:quotum_limit) { create(:quotum_limit, limit: 10) }
      let(:mock_service) { allow(ResourceQuotable::Update).to receive(:call).with({ quotum_limit: quotum_limit, limit: '10' }).and_return(quotum_limit) }

      it 'test allowed_to_manage_quota?' do
        allow(controller).to receive(:allowed_to_manage_quota?).and_return(false)
        expect { update }.to raise_error(ResourceQuotable::AuthorizationError)
      end

      describe 'JS format' do
        let(:xhr) { true }

        before do
          mock_service
          update
        end

        it { expect(response.content_type).to eq 'text/javascript; charset=utf-8' }
        it { expect(response).to render_template(:update) }
      end

      describe 'test allowed_to_manage_quota? true' do
        before do
          mock_service
          update
        end

        it { expect(ResourceQuotable::Update).to have_received(:call).with({ quotum_limit: quotum_limit, limit: '10' }) }
        it { expect(assigns(:quotum_limit)).to eq(quotum_limit) }
        it { expect(response).to redirect_to(action: :show, id: quotum_limit.id) }
        it { expect(response.content_type).to eq 'text/html; charset=utf-8' }
      end
    end

    describe 'DELETE destroy' do
      subject(:destroy) { delete :destroy, params: { id: quotum_limit.id }, xhr: xhr }

      let(:xhr) { false }

      let(:quotum_limit) { create(:quotum_limit) }

      let(:mock_service) { allow(ResourceQuotable::Destroy).to receive(:call).with({ quotum_limit: quotum_limit }).and_return(true) }

      it 'test allowed_to_manage_quota?' do
        allow(controller).to receive(:allowed_to_manage_quota?).and_return(false)
        expect { destroy }.to raise_error(ResourceQuotable::AuthorizationError)
      end

      describe 'JS format' do
        let(:xhr) { true }

        before do
          mock_service
          destroy
        end

        it { expect(response.content_type).to eq 'text/javascript; charset=utf-8' }
        it { expect(response).to render_template(:destroy) }
      end

      describe 'test allowed_to_manage_quota? true' do
        before do
          mock_service
          destroy
        end

        it { expect(ResourceQuotable::Destroy).to have_received(:call).with({ quotum_limit: quotum_limit }) }
        it { expect(assigns(:quotum_limit)).to eq(quotum_limit) }
        it { expect(assigns(:id)).to eq(quotum_limit.id) }
        it { expect(response).to redirect_to(action: :index) }
        it { expect(response.content_type).to eq 'text/html; charset=utf-8' }
      end
    end
  end
end
