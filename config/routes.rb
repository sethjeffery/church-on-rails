Rails.application.routes.draw do
  root to: 'home#index'

  authenticate do
    scope module: 'people' do
      resources :families do
        get :confirm_destroy, on: :member
        resources :family_memberships, path: 'memberships'
      end
      resources :teams do
        get :confirm_destroy, on: :member
        resources :team_memberships, path: 'memberships'
        resources :events, controller: '/events/events'
      end
      resources :people do
        get :confirm_destroy, on: :member
        resource :user
        resource :teams, controller: :person_teams
        resource :families, controller: :person_families
        resources :person_processes, path: 'processes'
      end
    end

    scope module: 'events' do
      resources :events do
        get :confirm_destroy, on: :member
      end
    end

    scope module: 'processes' do
      resources :church_processes, path: 'processes' do
        get :confirm_destroy, on: :member
        resources :person_processes, path: 'people'
      end
    end

    namespace :account do
      get '/' => 'people#show'
      as :user do
        get 'resend_confirmation' => 'confirmations#resend'
      end
      resource :person
    end
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
