Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace :api do
    namespace :v1 do
      resources :hello, only: [:index]
      resources :cards, only: [:index, :create, :show, :destroy, :update]
      resources :challenges, only: [:index, :create, :show, :destroy, :update]
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: 'api/v1/auth/registrations'
      }

      namespace :auth do
        resources :user, only: [:show]
      end
    end
  end
end
