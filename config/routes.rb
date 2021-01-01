Rails.application.routes.draw do
  root 'home#index'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: 'omniauth_callbacks'}
  scope "(:locale)", locale: /en|vi/ do
    # root "static_pages#home"
    devise_for :users, path: "auth", path_names: { sign_in: "login", sign_out: "logout", password: "secret", confirmation: "verification", unlock: "unblock", registration: "register" },
     skip: :omniauth_callbacks
    get "/search", to: "searchs#index"
    get "/clear-cart", to: "carts#clear_cart", as: :clear_cart
    post "/orders/new", to: "orders#voucher"
    delete "/orders/new", to: "orders#cancel_voucher"
    resources :products, only: :show do
      resources :ratings, only: %i(index create)
    end
    resources :categories, only: :show
    resources :users do
      resources :orders, only: %i(index show update) do
        resources :order_details, only: :index
      end
    end
    resources :carts, except: %i(show edit new)
    namespace :admin do
      root "base#home"
      resources :orders, only: %i(index update)
    end
    resources :orders, only: %i(new create)
  end
end
