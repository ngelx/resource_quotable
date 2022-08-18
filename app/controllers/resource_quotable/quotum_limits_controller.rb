# frozen_string_literal: true

module ResourceQuotable
  class QuotumLimitsController < ApplicationController
    def index
    end

    def show
    end

    def new
    end

    def create
    end

    def edit
    end

    def update
    end

    def destroy
    end

    protected

    def quotum_limits_params
      params.require(:quotum_limit).permit(:)
    end

  end
end
