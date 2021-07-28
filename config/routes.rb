# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'pages#dashboard'
  get 'query', to: 'pages#dashboard'
  get 'health', to: 'application#health'
  # resources :ships
  # resources :ports
end
