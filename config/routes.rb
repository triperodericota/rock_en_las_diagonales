Rails.application.routes.draw do

  devise_scope :user do
    get 'signup/(:type)', to: 'user/registrations#new', as: 'signup'
  end

  devise_for :user, controllers: {registrations: 'user/registrations', sessions: 'user/sessions' },
             path_names: { edit: 'profile', sign_in: 'login', sign_out: 'logout' }

  get 'welcome/index'
  get 'search', to: 'welcome#search'
  delete 'photos/:id', to: 'photos#destroy', as: 'photo'

  resources :artists, param: :name, only: [:index, :show, :destroy ] do
    resources :events do
      member do
        post 'add_event', to: 'fans#add_event', as: 'add'
        post 'remove_event', to: 'fans#remove_event', as: 'remove'
      end
    end
    member do
      post 'follow', to: 'fans#follow_artist'
      post  'unfollow', to: 'fans#unfollow_artist'
    end
    resources :products
  end

  resources :fans, only: [:index, :show, :destroy] do
    member do
      get 'my_events'
      get 'followed_artists'
    end
  end

  root to: 'welcome#index'
end
