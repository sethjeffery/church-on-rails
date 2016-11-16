Rails.application.routes.draw do
  resources :family_members
  resources :families
  resources :team_memberships
  resources :team_people
  resources :teams
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
