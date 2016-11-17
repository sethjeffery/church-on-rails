Rails.application.routes.draw do
  root to: 'home#index'

  scope module: 'people' do
    resources :families do
      resources :family_memberships, path: 'memberships'
    end
    resources :teams do
      resources :team_memberships, path: 'memberships'
    end
    resources :people do
      resources :users
    end
  end

  devise_for :users,
             sign_out_via: :get,
             controllers: {confirmations: 'users/confirmations'},
             path_names: {
               sign_in: 'login',
               sign_out: 'logout'
             }

  resources :users

end
