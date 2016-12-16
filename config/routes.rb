Rails.application.routes.draw do
  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  unauthenticated do
    root to: 'home#index'

    as :user do
      get 'users', to: redirect('/users/login')
    end
  end

  authenticated do
    root to: 'account/churches#show'
  end

  authenticate do
    scope module: 'people' do
      resources :families, concerns: :paginatable do
        get :confirm_destroy, on: :member
        resources :family_memberships, path: 'memberships'
      end
      resources :teams, concerns: :paginatable do
        get :confirm_destroy, on: :member
        resources :team_memberships, path: 'memberships'
        resources :events, controller: '/events/events'
      end
      resources :people, concerns: :paginatable do
        get :confirm_destroy, on: :member
        resource :user do
          resource :password
        end
        resource :teams, controller: :person_teams
        resource :families, controller: :person_families
        resources :person_processes, path: 'processes'
        resource :merge
      end
      resources :properties, concerns: :paginatable do
        get :confirm_destroy, on: :member
      end
    end

    scope module: 'events' do
      resources :events, concerns: :paginatable do
        get :confirm_destroy, on: :member
      end
    end

    scope module: 'processes' do
      resources :church_processes, concerns: :paginatable, path: 'processes' do
        get :confirm_destroy, on: :member
        resources :person_processes, path: 'people'
      end
    end

    scope module: 'children' do
      get 'children', to: redirect('children/groups')
      resources :child_groups, path: 'children/groups' do
        get :confirm_destroy, on: :member
        resources :child_group_memberships, path: 'memberships'
      end
    end

    namespace :kiosk do
      resources :child_groups, path: 'children/groups'
      resources :people, path: 'children'
      resources :check_ins
      resources :check_outs
    end

    namespace :account do
      get '/' => 'people#show'
      get 'welcome' => 'people#welcome', as: :welcome
      as :user do
        get 'resend_confirmation' => 'confirmations#resend'
      end
      resource :person
      resource :church
    end

    scope module: 'comments' do
      resources :comments
    end
  end

  devise_for :users,
             sign_out_via: :get,
             controllers: {
               confirmations: 'account/confirmations',
               registrations: 'account/registrations',
               omniauth_callbacks: 'account/omniauth_callbacks'
             },
             path_names: {
               sign_in: 'login',
               sign_out: 'logout'
             }

  resources :users

end
