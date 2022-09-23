# frozen_string_literal: true

module ResourceQuotable
  class QuotaController < ResourceQuotable::ApplicationController # :nodoc:
    layout ResourceQuotable.layout

    before_action :check_authorization
    before_action :load_quotum, only: %i[show edit update destroy]

    def index
      resource_quotable_before
      @page = params[:page] || 1
      @per_page = params[:per_page] || 5

      @quota = quota_scoped.page(@page).per(@per_page)
      resource_quotable_after
    end

    def show
      resource_quotable_before
      @quotum_trackers = @quotum.quotum_trackers.page(@page).per(@per_page)
      resource_quotable_after
    end

    def new
      resource_quotable_before
      @quotum = Quotum.new
      resource_quotable_after
    end

    def create
      resource_quotable_before
      @quotum = ResourceQuotable::Create.call(
        group: load_quotable_group || default_load_quotable_group,
        resource: quotum_params[:resource_class],
        action: quotum_params[:action].to_sym,
        period: quotum_params[:period].to_sym,
        limit: quotum_params[:limit].to_i
      )
      resource_quotable_after
      respond_to do |format|
        format.html do
          flash[:notice] = 'Quotum created'
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
      @quotum = ResourceQuotable::Update.call(
        quotum: @quotum,
        limit: quotum_edit_params[:limit].to_i
      )
      resource_quotable_after
      respond_to do |format|
        format.html do
          flash[:notice] = 'Quotum updated'
          redirect_to action: :show, id: @quotum.id
        end
        format.js
      end
    end

    def destroy
      resource_quotable_before
      @id = @quotum.id
      ResourceQuotable::Destroy.call(quotum: @quotum)
      resource_quotable_after
      respond_to do |format|
        format.html do
          flash[:notice] = 'Quotum deleted'
          redirect_to action: :index
        end
        format.js
      end
    end

    protected

    def quotum_params
      params.require(:quotum).permit(
        :period,
        :limit,
        :resource_class,
        :action,
        :group_id,
        :group_type
      )
    end

    def quotum_edit_params
      params.require(:quotum).permit(:limit)
    end

    def load_quotum
      @quotum = quota_scoped.find(params[:id])
    end
  end
end
