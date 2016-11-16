Rails.application.routes.draw do
  devise_for :users,
             sign_out_via: :get,
             controllers: {confirmations: 'users/confirmations'},
             path_names: {
               sign_in: 'login',
               sign_out: 'logout'
             }

  resources :users

end
