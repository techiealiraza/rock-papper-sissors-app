Rails.application.routes.draw do
  resources :matches
  resources :messages
  resources :tournaments do
    member do
      post 'registration'
    end
  end
  resources :tournaments do
    get '/page/:page', action: :index, on: :collection
  end
  resources :matches do
    get '/page/:page', action: :index, on: :collection
    get '/playmatch', to: 'matches#playmatch', as: 'playmatch'
    resources :messages
  end
  get 'rockpaperscissor/home'
  post 'matches/create_matches', to: 'matches#create_matches', as: 'create_matches'
  # get 'matches/view_match', to: 'matches#matches_index', as: 'matches_index'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'registrations'
  }
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  root 'rockpaperscissor#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
