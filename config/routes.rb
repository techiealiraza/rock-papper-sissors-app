Rails.application.routes.draw do
  resources :tournaments
  get 'rockpaperscissor/home'
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  root 'rockpaperscissor#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
