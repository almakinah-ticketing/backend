Rails.application.routes.draw do
   
  resources :attendees do 
    post 'confirmations', to: 'attendees#confirm', on: :collection
    post 'logins', to: 'attendees#login', on: :collection
  end

  resources :admins do
    post 'confirmations', to: 'admins#confirm', on: :collection
    post 'logins', to: 'admins#login', on: :collection
  end

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
  get '/admin_activities', to: 'admin_activities#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

