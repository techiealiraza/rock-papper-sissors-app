# frozen_string_literal: true

require 'delayed_job_web'
Rails.application.routes.draw do
  get 'leaderboard/index'
  patch 'user_otp/enable'
  get 'user_otp/disable'
  match '/delayed_job' => DelayedJobWeb, :anchor => false, :via => %i[get post]
  resources :selection

  get '/matches_all', to: 'matches#all'

  resources :tournaments do
    member do
      post 'register'
      post '/create_matches', to: 'tournaments#create_matches'
    end
    resources :matches do
      member do
        get '/playmatch', to: 'matches#playmatch', as: 'playmatch'
        get '/result', to: 'matches#result', as: 'result'
      end
      resources :messages, only: [:create]
    end
  end
  get 'rockpaperscissor/home'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  root 'tournaments#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
