Rails.application.routes.draw do
   
  resources :attendees do 
    post 'confirmations', to: 'attendees#confirm', on: :collection
    post 'logins', to: 'attendees#login', on: :collection
  end
  post 'admin/invitations', to: 'admin_invitation#invitation'

  resources :admins do
    post 'confirmations', to: 'admins#confirm', on: :collection
    post 'logins', to: 'admins#login', on: :collection



    collection do
      get 'registration/:invitation_token', to: 'invited_admin_registration#show'
    end
    patch 'registration', to: 'invited_admin_registration#update'
  end

  resources :admin_activities, only: [:index, :create]

  resources :charges
  resources :categories

   resources :events do
    resources :types do
      resources :tickets
    end
  end

  #custom routes:
  # get '/events', :to =>  'events#all'
  # get 'find/events', :to =>  'events#filters'
  # get 'filter/events', :to =>  'events#double_filter'
  # match '/events/hottest', to: 'events#hot', via: :get
  post '/buy', :to => 'tickets#create'
  get '/history', :to => 'events#history'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

