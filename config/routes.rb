Rails.application.routes.draw do
  resources :doctors

  root 'doctors#index'
end