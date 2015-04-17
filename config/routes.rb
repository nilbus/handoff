Rails.application.routes.draw do
  resources "patients", only: [:index, :show], id: /[^\/]+/
  resources "handoffs", only: [:index, :show, :create, :destroy]
  resources "annotations", only: [:create, :update, :destroy]
  resources "shares", only: [:create, :destroy]

  #override devise's new_user_registration path before it is set by devise so that unsigned in attempts to access protected pages redirect the user to the app root
  get '/users/sign_in', to: redirect('/'), as: 'new_user_registration'

  devise_for :users

  root "welcome#index"

  get 'about'   => 'welcome#about'
  get 'contact' => 'welcome#contact'


  
end
