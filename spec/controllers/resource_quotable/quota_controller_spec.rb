# frozen_string_literal: true

require 'rails_helper'

module ResourceQuotable
  RSpec.describe QuotaController do
    routes { ResourceQuotable::Engine.routes }

    describe 'GET index' do
      subject(:index) { get :index }

      let(:quota) { create_list(:quotum, 3) }

      before { quota }

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
        it { expect(assigns(:quota)).to eq(quota) }
        it { expect(response).to render_template('index') }
      end
    end

    describe 'GET show' do
      subject(:show) { get :show, params: { id: quotum.id } }

      let(:quotum) { create(:quotum) }

      it 'test allowed_to_manage_quota?' do
        allow(controller).to receive(:allowed_to_manage_quota?).and_return(false)
        expect { show }.to raise_error(ResourceQuotable::AuthorizationError)
      end

      it 'Accept js format' do
        get :show, params: { id: quotum.id }, xhr: true
        expect(response.content_type).to eq 'text/javascript; charset=utf-8'
      end

      describe 'test allowed_to_manage_quota? true' do
        before { show }

        it { expect(response.content_type).to eq 'text/html; charset=utf-8' }
        it { expect(assigns(:quotum)).to eq(quotum) }
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
        it { expect(assigns(:quotum)).to be_kind_of(ResourceQuotable::Quotum) }
        it { expect(assigns(:quotum).persisted?).to be false }
        it { expect(response).to render_template('new') }
      end
    end

    describe 'POST create' do
      subject(:create) { post :create, params: { quotum: { limit: 10, period: 'daily', group_id: group.id, resource_class: 'ClassA', action: 'destroy' } }, xhr: xhr }

      let(:group) { build(:user_group) }
      let(:xhr) { false }
      let(:quotum) { build(:quotum, group: group) }
      let(:mock_service) { allow(ResourceQuotable::Create).to receive(:call).with({ group: group, resource: 'ClassA', action: :destroy, period: :daily, limit: 10 }).and_return(quotum) }

      before { group.save }

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

        it { expect(ResourceQuotable::Create).to have_received(:call).with({ group: group, resource: 'ClassA', action: :destroy, period: :daily, limit: 10 }) }
        it { expect(assigns(:quotum)).to eq(quotum) }
        it { expect(response).to redirect_to(action: :index) }
        it { expect(response.content_type).to eq 'text/html; charset=utf-8' }
      end
    end

    describe 'GET edit' do
      subject(:edit) { get :edit, params: { id: quotum.id } }

      let(:quotum) { create(:quotum) }

      it 'test allowed_to_manage_quota?' do
        allow(controller).to receive(:allowed_to_manage_quota?).and_return(false)
        expect { edit }.to raise_error(ResourceQuotable::AuthorizationError)
      end

      it 'Accept js format' do
        get :edit, params: { id: quotum.id }, xhr: true
        expect(response.content_type).to eq 'text/javascript; charset=utf-8'
      end

      describe 'test allowed_to_manage_quota? true' do
        before { edit }

        it { expect(assigns(:quotum)).to eq(quotum) }
        it { expect(response).to render_template('edit') }
        it { expect(response.content_type).to eq 'text/html; charset=utf-8' }
      end
    end

    describe 'PUT update' do
      subject(:update) { put :update, params: { id: quotum.id, quotum: { limit: 10 } }, xhr: xhr }

      let(:xhr) { false }
      let(:quotum) { create(:quotum, limit: 10) }
      let(:mock_service) { allow(ResourceQuotable::Update).to receive(:call).with({ quotum: quotum, limit: 10 }).and_return(quotum) }

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

        it { expect(ResourceQuotable::Update).to have_received(:call).with({ quotum: quotum, limit: 10 }) }
        it { expect(assigns(:quotum)).to eq(quotum) }
        it { expect(response).to redirect_to(action: :show, id: quotum.id) }
        it { expect(response.content_type).to eq 'text/html; charset=utf-8' }
      end
    end

    describe 'DELETE destroy' do
      subject(:destroy) { delete :destroy, params: { id: quotum.id }, xhr: xhr }

      let(:xhr) { false }

      let(:quotum) { create(:quotum) }

      let(:mock_service) { allow(ResourceQuotable::Destroy).to receive(:call).with({ quotum: quotum }).and_return(true) }

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

        it { expect(ResourceQuotable::Destroy).to have_received(:call).with({ quotum: quotum }) }
        it { expect(assigns(:quotum)).to eq(quotum) }
        it { expect(assigns(:id)).to eq(quotum.id) }
        it { expect(response).to redirect_to(action: :index) }
        it { expect(response.content_type).to eq 'text/html; charset=utf-8' }
      end
    end
  end
end
