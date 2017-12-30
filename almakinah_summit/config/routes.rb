Rails.application.routes.draw do
  resources :categories

   resources :events do
    resources :types do
      resources :tickets
    end
  end

  resources :attendees

  resources :admins

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

