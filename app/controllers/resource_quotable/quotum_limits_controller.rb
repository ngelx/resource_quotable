# frozen_string_literal: true

module ResourceQuotable
  class QuotumLimitsController < ApplicationController # :nodoc:
    layout ResourceQuotable.layout

    before_action :check_authorization
    before_action :load_quotum_limit, only: %i[show edit update destroy]

    def index
      resource_quotable_before
      @page = params[:page] || 1
      @per_page = params[:per_page] || 5

      @quotum_limits = QuotumLimit.page(@page).per(@per_page)
      resource_quotable_after
    end

    def show
      resource_quotable_before
      resource_quotable_after
    end

    def new
      resource_quotable_before
      @quotum_limit = QuotumLimit.new
      @quotum_limit.build_quotum
      resource_quotable_after
    end

    def create
      resource_quotable_before
      @quotum_limit = ResourceQuotable::Create.call(
        user_id: quotum_limit_params[:quotum][:user_id],
        resource: quotum_limit_params[:quotum][:resource_class],
        action: quotum_limit_params[:quotum][:action].to_sym,
        period: quotum_limit_params[:period].to_sym,
        limit: quotum_limit_params[:limit].to_i
      )
      resource_quotable_after
      respond_to do |format|
        format.html do
          flash[:notice] = 'QuotumLimit created'
          redirect_to action: :index
        end
        format.js
      end
    end

    def edit
      resource_quotable_before
      resource_quotable_after
    end

    def update
      resource_quotable_before
      @quotum_limit = ResourceQuotable::Update.call(
        quotum_limit: @quotum_limit,
        limit: quotum_limit_edit_params[:limit].to_i
      )
      resource_quotable_after
      respond_to do |format|
        format.html do
          flash[:notice] = 'QuotumLimit updated'
          redirect_to action: :show, id: @quotum_limit.id
        end
        format.js
      end
    end

    def destroy
      resource_quotable_before
      @id = @quotum_limit.id
      ResourceQuotable::Destroy.call(quotum_limit: @quotum_limit)
      resource_quotable_after
      respond_to do |format|
        format.html do
          flash[:notice] = 'QuotumLimit deleted'
          redirect_to action: :index
        end
        format.js
      end
    end

    protected

    def quotum_limit_params
      params.require(:quotum_limit).permit(
        :period,
        :limit,
        quotum: %i[user_id resource_class action]
      )
    end

    def quotum_limit_edit_params
      params.require(:quotum_limit).permit(:limit)
    end

    def load_quotum_limit
      @quotum_limit = QuotumLimit.find(params[:id])
    end

    def check_authorization
      raise ResourceQuotable::AuthorizationError unless allowed_to_manage_quota?
    end
  end
end
