# frozen_string_literal: true

ResourceQuotable::Engine.routes.draw do
  resources :quota

  resources :quotum_trackers, only: [] do
    put :reset, on: :member
  end

  root 'quota#index'
end
