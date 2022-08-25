# frozen_string_literal: true

module ResourceQuotable
  class QuotumLimitsController < ApplicationController # :nodoc:
    before_action :check_authorization
    before_action :load_quotum_limit, only: %i[show edit update destroy]

    def index
      @page = params[:page] || 1
      @per_page = params[:per_page] || 5

      @quotum_limits = QuotumLimit.page(@page).per(@per_page)
    end

    def show; end

    def new
      @quotum = Quotum.new
      @quotum.quotum_limits.build
    end

    def create
      @quotum_limit = ResourceQuotable::Create.call(
        user_id: quotum_params[:user_id],
        resource: quotum_params[:resource_class],
        action: quotum_params[:action].to_sym,
        period: quotum_params[:quotum_limit][:period].to_sym,
        limit: quotum_params[:quotum_limit][:limit]
      )
    end

    def edit; end

    def update
      @quotum_limit = ResourceQuotable::Update.call(
        quotum_limit: @quotum_limit,
        limit: quotum_limit_params[:limit]
      )
    end

    def destroy
      @id = @quotum_limit.id
      ResourceQuotable::Destroy.call(quotum_limit: @quotum_limit)
    end

    protected

    def quotum_params
      params.require(:quotum).permit(
        :user_id,
        :resource_class,
        :action,
        quotum_limit: %i[period limit]
      )
    end

    def quotum_limit_params
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
