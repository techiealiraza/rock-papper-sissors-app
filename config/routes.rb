# frozen_string_literal: true

require 'delayed_job_web'
Rails.application.routes.draw do
<<<<<<< HEAD
  match '/delayed_job' => DelayedJobWeb, :anchor => false, :via => %i[get post]
=======
  patch 'user_otp/enable'
  get 'user_otp/disable'
>>>>>>> f6fda3f (OTP Mail Finalized)
  resources :selection
  resources :matches
  resources :messages
  resources :tournaments do
    member do
      post 'register'
    end
  end
  resources :tournaments do
    get '/page/:page', action: :index, on: :collection
  end
  resources :matches do
    get '/page/:page', action: :index, on: :collection
    get '/playmatch', to: 'matches#playmatch', as: 'playmatch'
    get '/result', to: 'matches#result', as: 'result'
    resources :messages, only: [:create]
    member do
      get :playmatch
    end
  end
  get 'rockpaperscissor/home'
  post 'matches/create_matches', to: 'matches#create_matches', as: 'create_matches'
  # get 'matches/view_match', to: 'matches#matches_index', as: 'matches_index'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  root 'rockpaperscissor#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
