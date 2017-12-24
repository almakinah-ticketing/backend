Rails.application.routes.draw do
  resources :tickets
  resources :types
  resources :events
  resources :categories
  resources :attendees
  resources :admins
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
