Rails.application.routes.draw do
  
  # root :to => "events#get_all"
  get '/events', :to =>  'events#index'

  # remove
  get 'find/events', :to =>  'events#filters'
  get 'filter/events', :to =>  'events#double_filter'
  
  #   collection do
  #     get '/events_all', :to =>  'events#get_all'
    
  #   end 
  
  resources :categories do
    resources :events do
      resources :types do
        resources :tickets
      end
    end
  end

  get 'categories/:id/events&starts_with=', to: 'event#filter'

  resources :attendees
  resources :admins
  resources :events
  resources :types
  resources :tickets

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

