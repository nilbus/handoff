Rails.application.routes.draw do
  resources "patients", only: [:index, :show]
  resources "handoffs", only: [:index, :show, :create, :destroy]
  resources "annotations", only: [:create, :update, :destroy]
  resources "shares", only: [:create, :destroy]

  devise_for :users

  root "welcome#index"

  get 'about'   => 'welcome#about'
  get 'contact' => 'welcome#contact'
  
end
