Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find', controller: :merchant_find, action: :find
      end
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: 'merchant_items'
      end
      resources :items do
        get '/merchant', controller: :item_merchants, action: :show
      end
    end
  end
end
