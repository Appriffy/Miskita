Rails.application.routes.draw do
  # to redirect to admin on root
  root 'admin/dashboard#index'
  # resources :events
  # resources :servers
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '/api' do
    #add our register route
    post 'auth/register', to: 'users#register'
    post 'auth/login', to: 'users#login'
    post 'users/forgot-password', to: 'users#forgot_password'
    post 'users/change-password', to: 'users#change_password'
    get 'users/email-test', to: 'users#email_test'
    get 'users/events', to: 'users#getevents'
    post 'event/validate-access', to: 'events#checkaccesstoken'
    get 'event/detail', to: 'events#getevent'
  	resources :events
  end
  get '*path', to: "application#fallback_index_html", constraints: ->(request) do
  	!request.xhr? && request.format.html?
  end
end
