Rails.application.routes.draw do
  
  # root :to => "events#get_all"
  get '/events', :to =>  'events#all'
  get 'find/events', :to =>  'events#filters'
  get 'filter/events', :to =>  'events#double_filter'
  #   collection do
  #     get '/events_all', :to =>  'events#get_all'
    
  #   end 
  
  # resources :attendees
  # resources :admins
  # resources :events
  # resources :types
  # resources :tickets
  
  resources :categories, :only => [:index, :show] do
    resources :events,:only => [:index, :show, :hot, :create, :update, :destroy]  do
      resources :types, :only => [:index, :show, :create, :update, :destroy] do
        resources :tickets, :only => [:index, :show, :create, :destroy]
      end
    end
  end


  # GET "/events?start_datetime=2017-12-27%2007:21:33", :to =>  'event#index'


  # get ':start_datetime/events', to: 'event#filter'



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

