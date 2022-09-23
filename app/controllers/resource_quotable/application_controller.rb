# frozen_string_literal: true

module ResourceQuotable
  class ApplicationController < ResourceQuotable.base_controller  # :nodoc:
    protected

    def default_load_quotable_group
      quotum_params[:group_type].constantize.find(quotum_params[:group_id])
    end

    def check_authorization
      raise ResourceQuotable::AuthorizationError unless allowed_to_manage_quota?
    end
  end
end
