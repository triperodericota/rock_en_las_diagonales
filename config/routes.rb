Rails.application.routes.draw do

  resources :artists, param: :name, only: [:index, :show, :destroy ]
  resources :fans, only: [:index, :show, :destroy]

  devise_scope :user do
    get 'signup/(:type)', to: 'user/registrations#new', as: 'signup'
  end

  devise_for :user, controllers: {registrations: 'user/registrations', sessions: 'user/sessions' },
             path_names: { edit: 'profile', sign_in: 'login', sign_out: 'logout' }

  get 'welcome/index'

  root to: 'welcome#index'
end
