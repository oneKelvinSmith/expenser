Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controller: { passwords: 'passwords' }

  namespace :api do
    resources :users
    resources :expenses

    get :current_user, to: 'users#current'

    post :signup, to: 'signup#register'
  end

  mount_ember_app :frontend, to: '/'
end
