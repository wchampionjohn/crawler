Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  root 'index#index'

  namespace :pixnet do
    resources :users do
      resources :articles
      put 'fetch_articles', on: :member
      get 'sync/:account'  => "users#sync", on: :collection
    end

    resources :articles, except: [:new, :create] do
      put 'fetch_remote', on: :member
    end
  end

end
