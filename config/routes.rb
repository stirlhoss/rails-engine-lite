Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find', controller: :merchant_find, action: :find
      end
      resources :merchants, only: %i[index show] do
        resources :items, only: [:index], controller: 'merchant_items'
      end
      namespace :items do
        get '/find_all', controller: :items_find, action: :find_all
      end
      resources :items do
        get '/merchant', controller: :item_merchants, action: :show
      end
      namespace :revenue do
        resources :merchants, only: [:index]
      end
    end
  end
end
