Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controller: { passwords: 'passwords' }

  namespace :api do
    resources :users

    post :signup, to: 'signup#register'
  end

  root to: 'root#index'
end
