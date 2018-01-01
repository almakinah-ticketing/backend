Rails.application.routes.draw do
   
  resources :attendees
  resources :admins
  # resources :events
  # resources :types
  # resources :tickets
  
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
  get 'hot/event', :to => 'events#hot'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

