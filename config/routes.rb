Rails.application.routes.draw do

  resources :artists, param: :name, only: [:index, :show, :destroy ] do
    resources :events, only: [:new, :create, :destroy, :edit, :update]
    member do
      post 'follow', to: 'fans#follow_artist'
      post  'unfollow', to: 'fans#unfollow_artist'
    end
  end
  resources :events, only: [:show, :index] do
    member do
      post 'add_event', to: 'fans#add_event', as: 'add_artist'
      post 'remove_event', to: 'fans#remove_event', as: 'remove_artist'
    end
  end

  resources :fans, only: [:index, :show, :destroy]

  devise_scope :user do
    get 'signup/(:type)', to: 'user/registrations#new', as: 'signup'
  end

  devise_for :user, controllers: {registrations: 'user/registrations', sessions: 'user/sessions' },
             path_names: { edit: 'profile', sign_in: 'login', sign_out: 'logout' }

  get 'welcome/index'
  root to: 'welcome#index'
end
