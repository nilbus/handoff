Rails.application.routes.draw do
  resources "patients", only: [:index, :show]
  devise_for :users
  root "welcome#index"

  get 'about'   => 'welcome#about'
  get 'contact' => 'welcome#contact'
end
