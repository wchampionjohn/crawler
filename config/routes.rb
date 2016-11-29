Rails.application.routes.draw do
  root 'index#index'

  namespace :pixnet do
    resources :users do
      get 'sync/:account'  => "users#sync", on: :collection
    end
  end

end
