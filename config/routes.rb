Rails.application.routes.draw do
  get 'initial_setup/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  root to: 'initial_setup#index'
  
  resources :pages, only: :show
end
