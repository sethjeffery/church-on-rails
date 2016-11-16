Rails.application.routes.draw do
  resources :families do
    resources :family_memberships, path: 'memberships'
  end
  resources :teams do
    resources :team_memberships, path: 'memberships'
  end
  resources :people
  devise_for :users,
             sign_out_via: :get,
             controllers: {confirmations: 'users/confirmations'},
             path_names: {
               sign_in: 'login',
               sign_out: 'logout'
             }

  resources :users

end
