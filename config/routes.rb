Rails.application.routes.draw do

  resources :artists, param: :name, only: [:index, :show, :destroy ]
  resources :fans, only: [:index, :show, :destroy]

  devise_for :users, controllers: { registrations: 'user/registrations' }

  devise_scope :user do
    get 'artist/sign_up' => 'user/registrations#new', :users => {:user_type => 'artist' }
    get 'fan/sign_up' => 'user/registrations#new', :users => {:user_type => 'fan' }
  end

  get 'welcome/index'

  root to: 'welcome#index'
end
