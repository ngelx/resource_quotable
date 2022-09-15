# frozen_string_literal: true

ResourceQuotable::Engine.routes.draw do
  resources :quota

  root 'quota#index'
end
