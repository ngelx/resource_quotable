# frozen_string_literal: true

Rails.application.routes.draw do
  mount ResourceQuotable::Engine => '/resource_quotable'
end
