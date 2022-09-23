# frozen_string_literal: true

module ResourceQuotable
  class QuotumTrackersController < ResourceQuotable::ApplicationController # :nodoc:
    layout ResourceQuotable.layout

    before_action :check_authorization

    def reset
      resource_quotable_before

      @quotum_tracker = ResourceQuotable::QuotumTrackerServices::Reset.call(quotum_tracker: load_quotum_tracker)

      resource_quotable_after
    end

    protected

    def load_quotum_tracker
      QuotumTracker.find(params[:id])
    end
  end
end
