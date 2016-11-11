Rails.application.routes.draw do
  root 'index#index'

  namespace :pixnet do
    resources :users do
    end
  end

end
