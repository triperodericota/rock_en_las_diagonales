Rails.application.routes.draw do

  resources :artists, param: :name, only: [:index, :show, :destroy ]
  resources :fans, only: [:index, :show, :destroy]

  devise_scope :user do
    get '/sign_up/(:type)', to: 'user/registrations#new', as: 'sign_up'
    get 'profile', to: 'user/registrations#edit'
    get '/log_in', to: 'devise/sessions#new'
  end

  devise_for :users, controllers: { registrations: 'user/registrations' }

  get 'welcome/index'

  root to: 'welcome#index'
end
