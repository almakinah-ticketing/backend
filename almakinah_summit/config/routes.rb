Rails.application.routes.draw do
  
  
  resources :categories do
    resources :events do
      resources :types do
        resources :tickets
      end
    end
  end
  resources :attendees
  resources :admins
  resources :events
  resources :types
  resources :tickets
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
