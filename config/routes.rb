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
      resource :user
      resource :teams, controller: :person_teams
      resource :families, controller: :person_families
    end
  end

  namespace :account do
    get '/' => 'people#show'
    devise_scope :user do
      get 'resend_confirmation' => 'confirmations#resend'
    end
    resource :person
  end

  devise_for :users,
             sign_out_via: :get,
             controllers: {
               confirmations: 'account/confirmations',
               registrations: 'account/registrations'
             },
             path_names: {
               sign_in: 'login',
               sign_out: 'logout'
             }

  resources :users

end
